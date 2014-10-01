require 'gnuplot'

# Plot and display data on the screen.
#
# @param clusters [Array<Cluster>]
def plot(clusters)
  # Graph output by running gnuplot pipe
  Gnuplot.open do |gp|
    # Start a new plot
    Gnuplot::Plot.new(gp) do |plot|
      # Plot each cluster's points
      clusters.each do |cluster|
        # Collect all x and y coords for this cluster
        x = cluster.points.map(&:x)
        y = cluster.points.map(&:y)

        # Plot w/o a title (clutters things up)
        plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
          ds.notitle
        end

        # Centroid point as bigger black points
        x = [cluster.centroid.x]
        y = [cluster.centroid.y]

        plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
          ds.notitle
          ds.linecolor = '000000'
          ds.linewidth = 3
        end
      end
    end
  end
end
