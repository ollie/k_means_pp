$LOAD_PATH.unshift('../lib')

require 'bundler/setup'
require 'k_means_pp'
require './common'

# Generate an array of random n points around origin.
#
# @param n      [Fixnum] Number of points to generate.
# @param radius [Fixnum] How far to go from origin.
#
# @return [Array<Point>]
def generate_points(n, radius)
  n.times.map do
    random_radius = rand * radius
    random_angle  = rand * 2 * Math::PI
    x             = random_radius * Math.cos(random_angle)
    y             = random_radius * Math.sin(random_angle)

    KMeansPP::Point.new(x, y)
  end
end

points   = generate_points(30_000, 10)
clusters = KMeansPP.clusters(points, 7)
plot(clusters)
