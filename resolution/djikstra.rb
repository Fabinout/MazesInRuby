# frozen_string_literal: true

require_relative '../model/distance_grid'
require_relative '../generation/binary_tree'

grid = DistanceGrid.new(10,10)
BinaryTree.on(grid)

start = grid[0, 0]
distances = start.distances

grid.distances = distances
puts grid
