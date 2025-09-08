#!/bin/bash
# setup_tmux_maze.sh

# Créer une nouvelle session Tmux nommée "maze_demo"
tmux new-session -d -s maze_demo -n 'Maze Algorithms'

# Définir le chemin racine du projet
#PROJECT_ROOT="/home/fabien-lamarque/projects/MazesInRuby"
#PROJECT_ROOT="/home/fabien-lamarque/RubymineProjects/MazesInRuby" #ubuntu
#PROJECT_ROOT="/mnt/c/Users/FL4B622L/RubymineProjects/MazesInRuby" #laptop edf
GENERATION_DIR="generation"
SCRIPTS_DIR="scripts"
MODEL_DIR="model"

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
tmux send-keys -t maze_demo:0.0 "cd $GENERATION_DIR && vim $MODEL_DIR/cell.rb " C-m
tmux send-keys -t maze_demo:0.1 "vim test_properties.rb" C-m
tmux send-keys -t maze_demo:0.2 "echo 'Prêt pour exécution'" C-m
tmux send-keys -t maze_demo:0.3 "echo 'Prêt pour visualisation'" C-m

# Sélectionner le premier panneau
tmux select-pane -t maze_demo:0.0

# Créer une nouvelle fenêtre "BinaryTree" avec 2 panneaux (séparation verticale)
tmux new-window -t maze_demo -n 'BinaryTree'
tmux split-window -h -t maze_demo:1
tmux send-keys -t maze_demo:1.0 "./RerunOnKey.sh $SCRIPTS_DIR/binary_tree_demo.rb 12" C-m
tmux send-keys -t maze_demo:1.1 "ruby $SCRIPTS_DIR/binary_tree_generator.rb 12" C-m

# Créer une nouvelle fenêtre "Essuie-glace" avec 2 panneaux (séparation verticale)
tmux new-window -t maze_demo -n 'SideWinder'
tmux split-window -h -t maze_demo:2
tmux send-keys -t maze_demo:2.0 "./RerunOnKey.sh $SCRIPTS_DIR/sidewinder_demo.rb 12" C-m
tmux send-keys -t maze_demo:2.1 "ruby $SCRIPTS_DIR/sidewinder_generator.rb 12" C-m

# Attacher à la session
tmux attach-session -t maze_demo

# Attacher à la session
tmux attach-session -t maze_demo

