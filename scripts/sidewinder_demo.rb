# frozen_string_literal: true

require_relative '../model/grid'
require_relative '../generation/sidewinder'

# Interprétation des arguments:
# - 0 arg  => 8x8 (par défaut)
# - 1 arg  => x x (carrée)
# - 2 args => x y (lignes, colonnes)
rows, cols = case ARGV.length
             when 0
               [8, 8]
             when 1
               begin
                 x = Integer(ARGV[0], 10)
                 raise ArgumentError if x <= 0
                 [x, x]
               rescue ArgumentError
                 abort "Usage: ruby binary_tree_demo.rb [taille] ou ruby binary_tree_demo.rb [lignes colonnes]\nExemples: ruby binary_tree_demo.rb 10   |   ruby binary_tree_demo.rb 20 30"
               end
             else
               begin
                 x = Integer(ARGV[0], 10)
                 y = Integer(ARGV[1], 10)
                 raise ArgumentError if x <= 0 || y <= 0
                 [x, y]
               rescue ArgumentError
                 abort "Usage: ruby binary_tree_demo.rb [taille] ou ruby binary_tree_demo.rb [lignes colonnes]\nExemples: ruby binary_tree_demo.rb 10   |   ruby binary_tree_demo.rb 20 30"
               end
             end

grid = Grid.new(rows, cols)
Sidewinder.on(grid)

puts grid
