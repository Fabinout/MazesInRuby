require_relative '../model/grid'
require_relative 'sidewinder'


grid = Grid.new(8, 8)
Sidewinder.on(grid)

grid.save_events('sw.json')

puts(grid)