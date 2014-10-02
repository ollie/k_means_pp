$LOAD_PATH.unshift('../lib')

require 'bundler/setup'
require 'k_means_pp'
require './common'

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    self.x = x
    self.y = y
  end
end

points = [
  Point.new(0.3968, 1.9431),
  Point.new(9.3348, 6.7843),
  Point.new(9.2882, 8.1347),
  Point.new(7.6768, 2.7362),
  Point.new(3.4434, 4.1910),
  Point.new(1.8097, 5.0884),
  Point.new(7.0698, 3.9285),
  Point.new(9.3820, 7.6790),
  Point.new(8.6092, 0.9651),
  Point.new(9.1981, 7.7493)
]

clusters = KMeansPP.clusters(points, 3) do |point|
  [point.x, point.y]
end
plot(clusters)
puts clusters
