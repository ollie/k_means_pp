$LOAD_PATH.unshift('../lib')

require 'bundler/setup'
require 'k_means_pp'

points = [
  { x: 0.3968, y: 1.9431 },
  { x: 9.3348, y: 6.7843 },
  { x: 9.2882, y: 8.1347 },
  { x: 7.6768, y: 2.7362 },
  { x: 3.4434, y: 4.1910 },
  { x: 1.8097, y: 5.0884 },
  { x: 7.0698, y: 3.9285 },
  { x: 9.3820, y: 7.6790 },
  { x: 8.6092, y: 0.9651 },
  { x: 9.1981, y: 7.7493 }
]

clusters = KMeansPP.clusters(points, 3) do |point|
  [point[:x], point[:y]]
end

puts clusters
