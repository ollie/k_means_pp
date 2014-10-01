class KMeansPP
  # Point of the data set or a centroid.
  class Point
    # X coordinate of the point.
    #
    # @return [Float]
    attr_accessor :x

    # Y coordinate of the point.
    #
    # @return [Float]
    attr_accessor :y

    # Group number is a cluster number.
    #
    # @return [Fixnum]
    attr_accessor :group

    # Create a new point (data set point or a centroid).
    #
    # @param x     [Float]  X coordinate of the point.
    # @param y     [Float]  Y coordinate of the point.
    # @param group [Fixnum] Group number is a cluster number.
    def initialize(x = 0.0, y = 0.0, group = 0)
      self.x     = x
      self.y     = y
      self.group = group
    end

    # Measure a 2D squared distance between two points.
    #
    # @param point [Point]
    #
    # @return [Float]
    def squared_distance_to(point)
      distance_x       = x - point.x
      distance_y       = y - point.y
      squared_distance = distance_x**2 + distance_y**2
      squared_distance
    end
  end
end
