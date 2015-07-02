class KMeansPP
  # Common methods for +Point+ and +Centroid+.
  class BasePoint
    # X coordinate of the point.
    #
    # @return [Float]
    attr_accessor :x

    # Y coordinate of the point.
    #
    # @return [Float]
    attr_accessor :y

    # Measure a 2D squared distance between two points.
    #
    # @param point [BasePoint]
    #
    # @return [Float]
    def squared_distance_to(point)
      distance_x       = x - point.x
      distance_y       = y - point.y
      squared_distance = distance_x**2 + distance_y**2
      squared_distance
    end

    # A string representation of the point.
    def to_s
      "(#{x}, #{y})"
    end
  end

  # Point of the data set.
  class Point < BasePoint
    # Group is a centroid point.
    #
    # @return [Centroid]
    attr_accessor :group

    # The original object (could be anything from Hash to an Object).
    #
    # @return [Object]
    attr_accessor :original

    # Create a new point (data set point or a centroid).
    #
    # @param x     [Float]    X coordinate of the point.
    # @param y     [Float]    Y coordinate of the point.
    # @param group [Centroid] Group is a centroid point.
    def initialize(x = 0.0, y = 0.0, group = nil)
      self.x     = x
      self.y     = y
      self.group = group
    end
  end

  # Centroid of a cluster.
  class Centroid < BasePoint
    # How many points are in this cluster?
    #
    # @return [Fixnum]
    attr_accessor :counter

    # Create a new centroid point.
    #
    # @param point [Point] Copy point's X and Y coords.
    def initialize(point)
      self.x = point.x
      self.y = point.y
    end

    # Prepare centroid for a new iteration, zero-ing everything.
    def reset
      self.x       = 0.0
      self.y       = 0.0
      self.counter = 0
    end

    # Add this point's X and Y coords into the sum (for later average).
    #
    # @param point [Point]
    def add(point)
      self.counter += 1
      self.x += point.x
      self.y += point.y
    end

    # At this point X and Y properties will contain sums of all the point
    # coords, counter will contain number of those points.
    # By averaging the coords we find a new center.
    def average
      self.x /= counter
      self.y /= counter
    end
  end
end
