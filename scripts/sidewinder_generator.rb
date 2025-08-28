# ruby

# Placez ce script à la racine du projet (adaptez les chemins si nécessaire)
require 'json'
require_relative '../model/grid'
require_relative '../generation/sidewinder'
DEFAULT_SIZE = 12

# Taille par défaut (modifiable via arguments : 0=12x12, 1=x*x, 2=x y)
rows, cols = case ARGV.length
when 0
               [DEFAULT_SIZE, DEFAULT_SIZE]
             when 1
               x = Integer(ARGV[0], 10)
               raise ArgumentError, 'La taille doit être > 0' if x <= 0
               [x, x]
             else
               x = Integer(ARGV[0], 10)
               y = Integer(ARGV[1], 10)
               raise ArgumentError, 'Les tailles doivent être > 0' if x <= 0 || y <= 0
               [x, y]
             end

json_file = 'sidewinder_demo.json'

while true

  begin
    # 1) Génération
    grid = Grid.new(rows, cols)
    Sidewinder.on(grid)

    # 2) Sauvegarde des événements
    grid.save_events(json_file)
    puts "Événements enregistrés dans #{json_file}"

    # 3) Affichage pas à pas en rejouant chaque étape
    events = JSON.parse(File.read(json_file))
    create_evt = events.find { |e| e['type'] == 'GridCreatedEvent' }
    raise 'Aucun événement de création de grille trouvé' unless create_evt

    replay = Grid.new(create_evt['rows'], create_evt['columns'])

    # Affiche l’état initial (grille vide)
    system('clear') || system('cls')
    puts replay
    speed = 0.1
    # Rejoue chaque liaison et affiche après chaque étape
    events.each do |e|
      next unless e['type'] == 'CellsLinkedEvent'
      replay.link_cells(
        e['from_row'], e['from_column'],
        e['to_row'], e['to_column']
      )
      sleep speed
      # system('clear') || system('cls')
      puts replay
    end

    # 4) Pause 5 secondes
    puts "Relecture terminée. Suppression de #{json_file} dans 5 secondes..."
    sleep 5

  ensure
    # 5) Suppression du fichier JSON
    if File.exist?(json_file)
      File.delete(json_file)
      puts "#{json_file} supprimé."
    end
  end
end