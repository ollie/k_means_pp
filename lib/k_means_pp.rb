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

  # Take an array of things as an argument and group them into K clusters.
  # By default array of arrays is is expected, but you can pass in an array
  # of anything.
  #
  # In which case you should also pass in a block which that does a
  # per-item translation to array of two numbers.
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
    min_index = point.group
    min_dist  = Float::INFINITY

    centroids.each_with_index do |centroid, i|
      d = centroid.squared_distance_to(point)

      next if min_dist <= d

      min_dist  = d
      min_index = i
    end

    [min_index, min_dist]
  end

  # Take an array of points as an argument and group them into K clusters.
  #
  # @param points         [Array]  Source data set of points.
  # @param clusters_count [Fixnum] Number of clusters ("k").
  # @yieldreturn [Array<Numeric>]
  def initialize(points, clusters_count)
    points.map! do |point|
      point = yield(point) if block_given?
      Point.new(point[0], point[1])
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
