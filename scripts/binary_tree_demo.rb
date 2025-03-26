# frozen_string_literal: true

require 'model/grid'
require 'generation/binary_tree'

grid = Grid.new(10, 10)
BinaryTree.on(grid)

puts grid
