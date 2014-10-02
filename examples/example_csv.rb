$LOAD_PATH.unshift('../lib')

require 'bundler/setup'
require 'k_means_pp'
require './common'
require 'csv'

points = CSV.foreach('points.csv').map do |row|
  [row[0].to_f, row[1].to_f]
end

clusters = KMeansPP.clusters(points, 3)

plot clusters
puts clusters
