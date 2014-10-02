require 'k_means_pp/version'
require 'k_means_pp/point'
require 'k_means_pp/cluster'

# Cluster data with the k-means++, k-means and Lloyd algorithm.
class KMeansPP
  # Source data set of points.
  #
  # @return [Array<Point>]
  attr_accessor :points

  # Centroid points
  #
  # @return [Array<Point>]
  attr_accessor :centroids

  # Take an array of things and group them into K clusters.
  #
  # If no block was given, an array of arrays (of two numbers) is expected.
  # At the end an array of +Cluster+s is returned, each wrapping
  # an array or arrays (of two numbers).
  #
  # If a block was given, the +points+ is likely an array of other things
  # like hashes or objects. The block is expected to return an array of two
  # numbers. At the end an array of +Cluster+s is returned, each wrapping
  # an array or original objects.
  #
  # @param points         [Array]  Source data set of points.
  # @param clusters_count [Fixnum] Number of clusters ("k").
  # @yieldreturn [Array<Numeric>]
  #
  # @return [Array<Cluster>]
  def self.clusters(points, clusters_count, &block)
    instance = new(points, clusters_count, &block)
    instance.group_points
    instance.centroids.map do |centroid|
      cluster_points = points.select { |p| p.group == centroid.group }

      if block
        cluster_points.map!(&:original)
      else
        cluster_points.map! { |p| [p.x, p.y] }
      end

      Cluster.new(centroid, cluster_points)
    end
  end

  # Index (group number) of the nearest centroid.
  #
  # @param point     [Point]        Measure distance of this point
  # @param centroids [Array<Point>] to those cluster centers
  #
  # @return [Fixnum]
  def self.nearest_centroid_index(point, centroids)
    nearest_centroid(point, centroids)[0]
  end

  # Distance of the nearest centroid.
  #
  # @param point     [Point]        Measure distance of this point
  # @param centroids [Array<Point>] to those cluster centers
  #
  # @return [Float]
  def self.nearest_centroid_distance(point, centroids)
    nearest_centroid(point, centroids)[1]
  end

  # Find the nearest centroid.
  #
  # @param point     [Point]        Measure distance of this point
  # @param centroids [Array<Point>] to those cluster centers
  #
  # @return [Array]
  def self.nearest_centroid(point, centroids)
    # Assume the current centroid is the closest.
    nearest_index    = point.group
    nearest_distance = Float::INFINITY

    centroids.each_with_index do |centroid, centroid_i|
      distance = centroid.squared_distance_to(point)

      next if distance >= nearest_distance

      nearest_distance = distance
      nearest_index    = centroid_i
    end

    [nearest_index, nearest_distance]
  end

  # Take an array of things and group them into K clusters.
  #
  # If no block was given, an array of arrays (of two numbers) is expected.
  # Internally we map them with +Point+ objects.
  #
  # If a block was given, the +points+ is likely an array of other things
  # like hashes or objects. In this case we will keep the original object
  # in a property and once we are done, we will swap those objects.
  # The block is expected to retun an array of two numbers.
  #
  # @param points         [Array]  Source data set of points.
  # @param clusters_count [Fixnum] Number of clusters ("k").
  # @yieldreturn [Array<Numeric>]
  def initialize(points, clusters_count)
    if block_given?
      points.map! do |point_obj|
        point_ary      = yield(point_obj)
        point          = Point.new(point_ary[0], point_ary[1])
        point.original = point_obj
        point
      end
    else
      points.map! do |point_ary|
        Point.new(point_ary[0], point_ary[1])
      end
    end

    self.points    = points
    self.centroids = clusters_count.times.map { Point.new }
  end

  # Group points into clusters.
  def group_points
    define_initial_clusters
    fine_tune_clusters
    cleanup
  end

  protected

  # K-means++ algorithm.
  #
  # Find initial centroids and assign points to their nearest centroid,
  # forming cells.
  def define_initial_clusters
    # Randomly choose a point as the first centroid.
    centroids[0] = points.sample.dup

    # Initialize an array of distances of every point.
    distances = points.size.times.map { 0.0 }

    centroids.each_with_index do |_, centroid_i|
      # Skip the first centroid as it's already picked but keep the index.
      next if centroid_i == 0

      # Sum points' distances to their nearest centroid
      distances_sum = 0.0

      points.each_with_index do |point, point_i|
        distance = self.class.nearest_centroid_distance(
          point,
          centroids[0...centroid_i]
        )
        distances[point_i] = distance
        distances_sum     += distance
      end

      # Randomly cut it.
      distances_sum *= rand

      # Keep subtracting those distances until we hit a zero (or lower)
      # in which case we found a new centroid.
      distances.each_with_index do |distance, point_i|
        distances_sum -= distance
        next if distances_sum > 0
        centroids[centroid_i] = points[point_i].dup
        break
      end
    end

    # Assign each point its nearest centroid.
    points.each do |point|
      point.group = self.class.nearest_centroid_index(point, centroids)
    end
  end

  # This is Lloyd's algorithm
  # https://en.wikipedia.org/wiki/Lloyd%27s_algorithm
  #
  # At this point we have our points already assigned into cells.
  #
  # 1. We calculate a new center for each cell.
  # 2. For each point find its nearest center and re-assign it if it changed.
  # 3. Repeat until a threshold has been reached.
  def fine_tune_clusters
    # When a number of changed points reaches this number, we are done.
    changed_threshold = points.size >> 10

    loop do
      calculate_new_centroids
      changed = reassign_points

      # Stop when 99.9% of points are good
      break if changed <= changed_threshold
    end
  end

  # For each cell calculate its center.
  # This is done by averaging X and Y coordinates.
  def calculate_new_centroids
    # Clear centroids.
    centroids.each do |centroid|
      centroid.x     = 0
      centroid.y     = 0
      centroid.group = 0 # Used as a counter for averaging
    end

    # Sum all X and Y coords into each point's centroid.
    points.each do |point|
      centroid        = centroids[point.group]
      centroid.group += 1 # Incremet counter
      centroid.x     += point.x
      centroid.y     += point.y
    end

    # And then average it to find a center.
    centroids.each do |centroid|
      centroid.x /= centroid.group
      centroid.y /= centroid.group
    end
  end

  # Loop through all the points and find their nearest centroid.
  # If it's a different one than current, change it ande take a note.
  #
  # @return [Fixnum] Number of changed points.
  def reassign_points
    changed = 0

    points.each do |point|
      centroid_i = self.class.nearest_centroid_index(point, centroids)
      next if centroid_i == point.group
      changed += 1
      point.group = centroid_i
    end

    changed
  end

  # Since we used group attribute as a counter, we need to re-assign it.
  def cleanup
    centroids.each_with_index do |centroid, i|
      centroid.group = i
    end
  end
end
