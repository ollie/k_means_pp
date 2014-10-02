$LOAD_PATH.unshift('../lib')

require 'bundler/setup'
require 'k_means_pp'
# require './common'
require 'ruby-prof'

# Generate an array of random n points around origin.
#
# @param n      [Fixnum] Number of points to generate.
# @param radius [Fixnum] How far to go from origin.
#
# @return [Array<Array>]
def generate_points(n, radius)
  n.times.map do
    random_radius = rand * radius
    random_angle  = rand * 2 * Math::PI
    x             = random_radius * Math.cos(random_angle)
    y             = random_radius * Math.sin(random_angle)

    [x, y]
  end
end

clusters = nil

result = RubyProf.profile do
  points   = generate_points(100, 10)
  clusters = KMeansPP.clusters(points, 5)
end

printer = RubyProf::FlatPrinter.new(result)
printer.print(File.open('report-flat.txt', 'w'), min_percent: 2)

printer = RubyProf::GraphPrinter.new(result)
printer.print(File.open('report-graph.txt', 'w'), min_percent: 2)

printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(File.open('report-graph.html', 'w'), min_percent: 2)

printer = RubyProf::DotPrinter.new(result)
printer.print(File.open('report-dot.dot', 'w'), min_percent: 2)

# Then run:
# dot -Tpng report-dot.dot > report-graph.png

# plot(clusters)
