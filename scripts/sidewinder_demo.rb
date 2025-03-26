# frozen_string_literal: true

require 'model/grid'
require 'generation/sidewinder'

grid = Grid.new(6,6)
Sidewinder.on(grid)

puts grid
