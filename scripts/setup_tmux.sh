#!/bin/bash
# setup_tmux_maze.sh

# Créer une nouvelle session Tmux nommée "maze_demo"
tmux new-session -d -s maze_demo -n 'Maze Algorithms'

# Diviser la fenêtre en 4 panneaux
# Layout:
# +----------------+----------------+
# |                |                |
# |    Code        |    Tests       |
# |                |                |
# +----------------+----------------+
# |                |                |
# |    Execution   |  Visualization |
# |                |                |
# +----------------+----------------+

tmux split-window -h -t maze_demo:0     # Diviser en deux colonnes

tmux split-window -v -t maze_demo:0.0   # Diviser la première colonne en deux lignes

tmux split-window -v -t 2 # Diviser la deuxième colonne en deux lignes

# Nommer les panneaux pour plus de clarté
tmux select-pane -t maze_demo:0.0 -T "Code Source"
tmux select-pane -t maze_demo:0.1 -T "Tests de Propriétés"
tmux select-pane -t maze_demo:0.2 -T "Exécution"
tmux select-pane -t maze_demo:0.3 -T "Visualisation"

# Configurer les commandes initiales dans chaque panneau
tmux send-keys -t maze_demo:0.0 'cd ~/maze_project && vim -O binary_tree.rb sidewinder.rb' C-m
tmux send-keys -t maze_demo:0.1 'cd ~/maze_project && vim test_properties.rb' C-m
tmux send-keys -t maze_demo:0.2 'cd ~/maze_project && echo "Prêt pour exécution"' C-m
tmux send-keys -t maze_demo:0.3 'cd ~/maze_project && echo "Prêt pour visualisation"' C-m

# Sélectionner le premier panneau
tmux select-pane -t maze_demo:0.0

# Attacher à la session
tmux attach-session -t maze_demo

