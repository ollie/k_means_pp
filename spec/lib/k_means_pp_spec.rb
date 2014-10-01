require 'spec_helper'
require 'csv'

RSpec.describe 'Superman' do
  it 'does it again' do
    points = CSV.foreach('./spec/resources/points.csv').map do |row|
      KMeansPP::Point.new(row[0].to_f, row[1].to_f)
    end

    clusters = KMeansPP.clusters(points, 3)

    expect(clusters.size).to eq(3)
    expect(clusters.map { |c| c.centroid.group }).to eq([0, 1, 2])

    clusters.each do |cluster|
      expect(cluster.points.size).to be > 0
    end

    expect(clusters.first.to_s.size).to be > 1_000
  end
end
