# frozen_string_literal: true

require_relative '../model/distance_grid'
require_relative '../generation/sidewinder'

grid = DistanceGrid.new(8, 12)
Sidewinder.on(grid)

start = grid[grid.rows - 1, 0]
distances = start.distances

grid.distances = distances
puts grid

puts "path from northwest corner to southwest corner:"
grid.distances = distances.path_to(grid[0, grid.columns - 1])
puts grid.to_s
