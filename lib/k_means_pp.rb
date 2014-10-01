require 'k_means_pp/version'
require 'k_means_pp/point'
require 'k_means_pp/cluster'

# K-means++ is an algorithm for choosing the initial values (or "seeds") for the
# k-means clustering algorithm.
class KMeansPP
  # Source data set of points.
  #
  # @return [Array<Point>]
  attr_accessor :points

  # Number of clusters ("k").
  #
  # @return [Fixnum]
  attr_accessor :clusters_count

  # Centroid points
  #
  # @return [Array<Point>]
  attr_accessor :centroids

  # Take an array of points as an argument and group them into K clusters.
  #
  # @param points         [Array<Point>] Source data set of points.
  # @param clusters_count [Fixnum]       Number of clusters ("k").
  #
  # @return [Array<Cluster>]
  def self.clusters(points, clusters_count)
    instance = new(points, clusters_count)
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

      if min_dist > d
        min_dist  = d
        min_index = i
      end
    end

    [min_index, min_dist]
  end

  # Take an array of points as an argument and group them into K clusters.
  #
  # @param points         [Array<Point>] Source data set of points.
  # @param clusters_count [Fixnum]       Number of clusters ("k").
  def initialize(points, clusters_count)
    self.points         = points
    self.clusters_count = clusters_count
  end

  # Run Lloyd's algorithm and k-means++ algorithm.
  def group_points
    lloyd_algorithm
  end

  # This is Lloyd's algorithm
  # https://en.wikipedia.org/wiki/Lloyd%27s_algorithm
  def lloyd_algorithm
    self.centroids = clusters_count.times.map { Point.new }

    k_means_plus_plus

    lenpts10 = points.size >> 10

    loop do
      # group element for centroids are used as counters
      centroids.each do |centroid|
        centroid.x     = 0
        centroid.y     = 0
        centroid.group = 0
      end

      points.each do |p|
        centroids[p.group].group += 1
        centroids[p.group].x     += p.x
        centroids[p.group].y     += p.y
      end

      centroids.each do |centroid|
        centroid.x /= centroid.group
        centroid.y /= centroid.group
      end

      # find closest centroid of each Point
      changed = 0

      points.each do |p|
        min_i = self.class.nearest_centroid_index(p, centroids)
        if min_i != p.group
          changed += 1
          p.group = min_i
        end
      end

      # stop when 99.9% of points are good
      break if changed <= lenpts10
    end

    centroids.each_with_index do |centroid, i|
      centroid.group = i
    end
  end

  # K-means++ algorithm.
  def k_means_plus_plus
    # Randomly choose a point as the first centroid.
    centroids[0] = points.sample.dup

    # Initialize an array of distances of every point.
    d = points.size.times.map { 0.0 }

    centroids.each_with_index do |_, i|
      # Skip the first centroid as it's already picked but keep the index.
      next if i == 0

      sum = 0
      points.each_with_index do |p, j|
        d[j] = self.class.nearest_centroid_distance(p, centroids[0...i])
        sum += d[j]
      end

      sum *= rand

      d.each_with_index do |di, j|
        sum -= di
        next if sum > 0
        centroids[i] = points[j].dup
        break
      end
    end

    points.each do |p|
      p.group = self.class.nearest_centroid_index(p, centroids)
    end
  end
end
