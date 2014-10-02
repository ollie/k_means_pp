require 'spec_helper'
require 'csv'

RSpec.describe 'Superman' do
  it 'does it again' do
    data = CSV.foreach('./spec/resources/points.csv').map do |row|
      [row[0].to_f, row[1].to_f]
    end

    clusters = KMeansPP.clusters(data, 3)

    clusters.each do |cluster|
      expect(cluster.points.size).to be > 0
      expect(cluster.centroid.x).to_not eq(0)
      expect(cluster.centroid.y).to_not eq(0)
      expect(cluster.to_s).to_not be_empty
    end

    expect(clusters.size).to eq(3)
    expect(clusters.map { |c| c.centroid.group }).to eq([0, 1, 2])
  end

  it 'array of arrays' do
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

    clusters = KMeansPP.clusters(data, 3)
    expect(clusters.size).to eq(3)
    expect(clusters.first.points.first).to be_a(Array)
  end

  it 'array of anything else with block' do
    data = [
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

    clusters = KMeansPP.clusters(data, 3) do |point|
      [point[:x], point[:y]]
    end

    expect(clusters.size).to eq(3)
    expect(clusters.first.points.first).to be_a(Hash)
  end
end
