# visualize.rb
require 'model/grid'
require 'generation/binary_tree'
require 'image_exporter'
require 'gif_creator'
require 'chunky_png'

grid = Grid.new(20, 20)
BinaryTree.on(grid)

# Exporter l'image du labyrinthe
png = ImageExporter.render_grid_to_png(grid)
png.save('binary_tree_maze.png')
system('display binary_tree_maze.png &')  # Afficher l'image (nécessite ImageMagick)

