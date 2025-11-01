# frozen_string_literal: true

require_relative '../model/distance_grid'
require_relative '../generation/aldous_broder'

grid = DistanceGrid.new(10,10)
AldousBroder.on(grid)

start = grid[0, 0]
distances = start.distances

grid.distances = distances
puts grid

puts "path from northwest corner to southwest corner:"
grid.distances = distances.path_to(grid[grid.rows - 1, 0])
puts grid.to_s
