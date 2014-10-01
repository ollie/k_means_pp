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
data = [
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

points   = data.map { |i| KMeansPP::Point.new(i[0], i[1]) }
clusters = KMeansPP.clusters(points, 3)
puts clusters
# Cluster (9.300774999999998, 7.586824999999999): [
#   (9.3348, 6.7843),
#   (9.2882, 8.1347),
#   (9.382, 7.679),
#   (9.1981, 7.7493),
# ]
# Cluster (1.8833, 3.7408333333333332): [
#   (0.3968, 1.9431),
#   (3.4434, 4.191),
#   (1.8097, 5.0884),
# ]
# Cluster (7.785266666666668, 2.5432666666666663): [
#   (7.6768, 2.7362),
#   (7.0698, 3.9285),
#   (8.6092, 0.9651),
# ]
```

## Running examples

If you want to run the examples, you will need `gnuplot` library and gem.
Don't forget to add the `--with-x` flag otherwise it won't show anything.

    $ brew install gnuplot --with-x # Assuming OS X
    $ gem install gnuplot
    $ cd examples
    $ ruby example_simple.rb
    $ ruby example_csv.rb
    $ ruby example_huge.rb

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
