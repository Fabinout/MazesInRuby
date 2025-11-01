# frozen_string_literal: true

require_relative '../model/grid'
require_relative '../generation/aldous_broder'
require_relative './cli'

# Interprétation des arguments:
# - 0 arg  => 8x8 (par défaut)
# - 1 arg  => x x (carrée)
# - 2 args => x y (lignes, colonnes)
rows, cols = CLI.parse_rows_cols(ARGV, default_size: 8)

grid = Grid.new(rows,cols)
AldousBroder.on(grid)

puts grid
