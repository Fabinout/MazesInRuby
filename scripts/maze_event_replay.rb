require_relative '../model/grid'

# Lecture du fichier maze_events.json et reconstruction du labyrinthe
maze = Grid.replay_from_file('sw.json')

# Affichage du labyrinthe
puts maze
