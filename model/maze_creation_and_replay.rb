require_relative 'grid'


# Création d'un nouveau labyrinthe
maze = Grid.new(4, 4)

# Création de liens entre les cellules
maze.link_cells(0, 0, 0, 1)
maze.link_cells(0, 1, 1, 1)
# ... autres liens ...

# Sauvegarder les événements dans un fichier
maze.save_events('maze_events.json')

# Plus tard, recréer le même labyrinthe
same_maze = Grid.replay_from_file('maze_events.json')
