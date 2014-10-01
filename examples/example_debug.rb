$LOAD_PATH.unshift('../lib')

require 'bundler/setup'
require 'k_means_pp'
require 'ruby-prof'

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

result = RubyProf.profile do
  points   = generate_points(10, 3)
  clusters = KMeansPP.clusters(points, 7)
end

printer = RubyProf::FlatPrinter.new(result)
printer.print(File.open('report-flat.txt', 'w'))

printer = RubyProf::GraphPrinter.new(result)
printer.print(File.open('report-graph.txt', 'w'))

printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(File.open('report-graph.html', 'w'))

printer = RubyProf::DotPrinter.new(result)
printer.print(File.open('report-dot.dot', 'w'))

# Then run:
# dot -Tpng report-dot.dot > report-graph.png
