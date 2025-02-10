# frozen_string_literal: true

require 'grid'
require 'sidewinder'

grid = Grid.new(6,6)
Sidewinder.on(grid)

puts grid
