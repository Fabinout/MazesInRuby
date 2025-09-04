# frozen_string_literal: true

require_relative '../model/grid'
require_relative '../generation/sidewinder'
require_relative './cli'

# Interprétation des arguments:
# - 0 arg  => 8x8 (par défaut)
# - 1 arg  => x x (carrée)
# - 2 args => x y (lignes, colonnes)
rows, cols = CLI.parse_rows_cols(ARGV, default_size: 8)

grid = Grid.new(rows, cols)
Sidewinder.on(grid)

puts grid
