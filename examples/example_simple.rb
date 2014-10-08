$LOAD_PATH.unshift('../lib')

require 'k_means_pp'
require './common'

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

plot clusters
puts clusters

cluster = clusters.first
p cluster.centroid.x
p cluster.centroid.y
p cluster.points
