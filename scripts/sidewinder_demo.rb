# frozen_string_literal: true

require_relative '../model/grid'
require_relative '../generation/sidewinder'

grid = Grid.new(6,6)
Sidewinder.on(grid)

puts grid
