# KMeansPP

## What's this?

This is a Ruby implementation of the k-means++ algorithm for data clustering.
In other words: Grouping a bunch of X, Y points into K groups.
The code is a port of the Python version on [rosettacode.org][rosetta].

### K-means++ (from [Wikipedia][kmeans++])

> In data mining, k-means++ is an algorithm for choosing the initial values (or
> "seeds") for the k-means clustering algorithm. It was proposed in 2007 by
> David Arthur and Sergei Vassilvitskii, as an approximation algorithm for the
> NP-hard k-means problem—a way of avoiding the sometimes poor clusterings found
> by the standard k-means algorithm.
>
> [...]
>
> The k-means problem is to find cluster centers that minimize the intra-class
> variance, i.e. the sum of squared distances from each data point being
> clustered to its cluster center (the center that is closest to it). Although
> finding an exact solution to the k-means problem for arbitrary input is
> NP-hard the standard approach to finding an approximate solution (often
> called [Lloyd's algorithm][lloyd] or the k-means algorithm) is used widely and
> frequently finds reasonable solutions quickly.

### K-means (from [Wikipedia][kmeans])

> k-means clustering is a method of vector quantization, originally from signal
> processing, that is popular for cluster analysis in data mining. k-means
> clustering aims to partition n observations into k clusters in which each
> observation belongs to the cluster with the nearest mean, serving as a
> prototype of the cluster. This results in a partitioning of the data space
> into Voronoi cells.

## Usage

See examples, too.

```ruby
points = [
  [0.3968, 1.9431],
  [9.3348, 6.7843],
  [9.2882, 8.1347],
  [7.6768, 2.7362],
  [3.4434, 4.1910],
  [1.8097, 5.0884],
  [7.0698, 3.9285],
  [9.3820, 7.6790],
  [8.6092, 0.9651],
  [9.1981, 7.7493]
]

clusters = KMeansPP.clusters(points, 3)
plot(clusters)
puts clusters
# Cluster (8.651271428571429, 5.4253): [
#   (9.3348, 6.7843),
#   (9.2882, 8.1347),
#   (7.6768, 2.7362),
#   (7.0698, 3.9285),
#   (9.382, 7.679),
#   (8.6092, 0.9651),
#   (9.1981, 7.7493),
# ]
# Cluster (0.3968, 1.9431): [
#   (0.3968, 1.9431),
# ]
# Cluster (2.62655, 4.6396999999999995): [
#   (3.4434, 4.191),
#   (1.8097, 5.0884),
# ]
```

Or with custom structure:

```ruby
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
# Cluster (1.10325, 3.51575): [
#   (0.3968, 1.9431),
#   (1.8097, 5.0884),
# ]
# Cluster (8.651271428571429, 5.4253): [
#   (9.3348, 6.7843),
#   (9.2882, 8.1347),
#   (7.6768, 2.7362),
#   (7.0698, 3.9285),
#   (9.382, 7.679),
#   (8.6092, 0.9651),
#   (9.1981, 7.7493),
# ]
# Cluster (3.4434, 4.191): [
#   (3.4434, 4.191),
# ]
```

## Running examples

If you want to run the examples, you will need `gnuplot` library and gem.
Don't forget to add the `--with-x` flag otherwise it won't show anything.

    $ brew install gnuplot --with-x # Assuming OS X
    $ gem install gnuplot
    $ cd examples
    $ ruby example_simple.rb
    $ ruby example_block.rb
    $ ruby example_csv.rb
    $ ruby example_huge.rb
    $ ruby example_debug.rb # Generates profiler reports

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'k_means_pp', require: 'KMeansPP'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install k_means_pp

## Contributing

1. Fork it (https://github.com/ollie/k_means_pp/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[rosetta]:  http://rosettacode.org/wiki/K-means%2B%2B_clustering#Python
[kmeans++]: https://en.wikipedia.org/wiki/K-means%2B%2B
[kmeans]:   https://en.wikipedia.org/wiki/K-means_clustering
[lloyd]:    https://en.wikipedia.org/wiki/Lloyd%27s_algorithm
