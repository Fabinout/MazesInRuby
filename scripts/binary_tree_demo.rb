# frozen_string_literal: true

require_relative '../model/grid'
require_relative '../generation/binary_tree'

grid = Grid.new(7, 7)
BinaryTree.on(grid)

puts grid
