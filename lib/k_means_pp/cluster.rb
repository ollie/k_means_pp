class KMeansPP
  # Cluster has a centroid and a group of related points.
  class Cluster
    # Center of the data set ("centroid").
    #
    # @return [Centroid]
    attr_accessor :centroid

    # Points in this cluster.
    #
    # @return [Array<Point>]
    attr_accessor :points

    # Create a new cluster with a centroid and points.
    #
    # @param centroid [Centroid]     Center point of the data set.
    # @param points   [Array<Point>] Points in this cluster.
    def initialize(centroid, points = [])
      self.centroid = centroid
      self.points   = points
    end

    # A string representation of the cluster.
    def to_s
      o = ''
      o << "Cluster #{centroid}: [\n"
      points.each { |p| o << "  #{p},\n" }
      o << "]\n"
      o
    end
  end
end
