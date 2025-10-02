# frozen_string_literal: true

require_relative '../model/grid'
require_relative '../generation/binary_tree'
require_relative '../generation/sidewinder'
require 'benchmark'

class MazeStatistics
  attr_reader :algorithm_name, :generation_times, :longest_paths,
              :dead_ends, :horizontal_bias, :vertical_bias,
              :longest_horizontal_paths, :longest_vertical_paths,
              :connectivity_checks

  def initialize(algorithm_name)
    @algorithm_name = algorithm_name
    @generation_times = []
    @longest_paths = []
    @dead_ends = []
    @horizontal_bias = []
    @vertical_bias = []
    @longest_horizontal_paths = []
    @longest_vertical_paths = []
    @connectivity_checks = []
  end

  def add_sample(grid, generation_time)
    @generation_times << generation_time
    @longest_paths << calculate_longest_path(grid)
    @dead_ends << count_dead_ends(grid)
    bias = calculate_directional_bias(grid)
    @horizontal_bias << bias[:horizontal]
    @vertical_bias << bias[:vertical]
    @longest_horizontal_paths << calculate_longest_horizontal_path(grid)
    @longest_vertical_paths << calculate_longest_vertical_path(grid)
    @connectivity_checks << check_full_connectivity(grid)
  end

  def average(array)
    return 0.0 if array.empty?
    array.sum.to_f / array.size
  end

  def all_connected?
    @connectivity_checks.all?
  end

  def print_summary
    puts "\n" + "=" * 70
    puts "  #{algorithm_name.upcase}"
    puts "=" * 70
    puts sprintf("  %-35s: %.4f ms (σ=%.4f)",
                 "Temps de génération moyen",
                 average(@generation_times) * 1000,
                 standard_deviation(@generation_times) * 1000)
    puts sprintf("  %-35s: %.2f cellules (σ=%.2f)",
                 "Longueur du plus long chemin",
                 average(@longest_paths),
                 standard_deviation(@longest_paths))
    puts sprintf("  %-35s: %.2f cellules (σ=%.2f)",
                 "Plus long chemin horizontal",
                 average(@longest_horizontal_paths),
                 standard_deviation(@longest_horizontal_paths))
    puts sprintf("  %-35s: %.2f cellules (σ=%.2f)",
                 "Plus long chemin vertical",
                 average(@longest_vertical_paths),
                 standard_deviation(@longest_vertical_paths))
    puts sprintf("  %-35s: %.2f cellules (σ=%.2f)",
                 "Nombre de culs-de-sac",
                 average(@dead_ends),
                 standard_deviation(@dead_ends))
    puts sprintf("  %-35s: %.2f%% (σ=%.2f%%)",
                 "Biais horizontal",
                 average(@horizontal_bias) * 100,
                 standard_deviation(@horizontal_bias) * 100)
    puts sprintf("  %-35s: %.2f%% (σ=%.2f%%)",
                 "Biais vertical",
                 average(@vertical_bias) * 100,
                 standard_deviation(@vertical_bias) * 100)

    connectivity_status = all_connected? ? "✓ OUI" : "✗ NON"
    connectivity_color = all_connected? ? "\e[32m" : "\e[31m"
    puts sprintf("  %-35s: %s%s\e[0m (%d/%d)",
                 "Labyrinthe valide (connecté)",
                 connectivity_color,
                 connectivity_status,
                 @connectivity_checks.count(true),
                 @connectivity_checks.size)
    puts "=" * 70
  end

  private

  def standard_deviation(array)
    return 0.0 if array.size <= 1
    mean = average(array)
    variance = array.map { |x| (x - mean) ** 2 }.sum / array.size
    Math.sqrt(variance)
  end

  def calculate_longest_path(grid)
    # Trouve le chemin le plus long dans le labyrinthe
    start = grid[0, 0]
    distances = start.distances

    # Trouve la cellule la plus éloignée du départ
    new_start, _ = distances.cells.max_by { |cell| distances[cell] }

    # Calcule les distances depuis cette nouvelle cellule
    new_distances = new_start.distances

    # Le plus long chemin est la distance maximale
    new_distances.cells.map { |cell| new_distances[cell] }.max || 0
  end

  def calculate_longest_horizontal_path(grid)
    # Parcourt toutes les cellules et trouve le plus long chemin horizontal
    max_horizontal = 0

    grid.each_cell do |cell|
      # Pour chaque cellule, on calcule le chemin horizontal le plus long
      # en allant vers l'est uniquement
      horizontal_length = calculate_horizontal_path_from(cell)
      max_horizontal = [max_horizontal, horizontal_length].max
    end

    max_horizontal
  end

  def calculate_horizontal_path_from(start_cell)
    # Calcule le chemin horizontal le plus long depuis une cellule
    # en utilisant un parcours en largeur mais uniquement horizontal
    visited = {}
    queue = [[start_cell, 0]]
    max_distance = 0

    while queue.any?
      cell, distance = queue.shift
      next if visited[cell]

      visited[cell] = true
      max_distance = [max_distance, distance].max

      # On ne suit que les liens horizontaux (est/ouest)
      cell.links.each do |neighbor|
        next if visited[neighbor]
        # Vérifie si le voisin est horizontal (même rangée)
        if neighbor.row == cell.row
          queue << [neighbor, distance + 1]
        end
      end
    end

    max_distance
  end

  def calculate_longest_vertical_path(grid)
    # Parcourt toutes les cellules et trouve le plus long chemin vertical
    max_vertical = 0

    grid.each_cell do |cell|
      # Pour chaque cellule, on calcule le chemin vertical le plus long
      vertical_length = calculate_vertical_path_from(cell)
      max_vertical = [max_vertical, vertical_length].max
    end

    max_vertical
  end

  def calculate_vertical_path_from(start_cell)
    # Calcule le chemin vertical le plus long depuis une cellule
    # en utilisant un parcours en largeur mais uniquement vertical
    visited = {}
    queue = [[start_cell, 0]]
    max_distance = 0

    while queue.any?
      cell, distance = queue.shift
      next if visited[cell]

      visited[cell] = true
      max_distance = [max_distance, distance].max

      # On ne suit que les liens verticaux (nord/sud)
      cell.links.each do |neighbor|
        next if visited[neighbor]
        # Vérifie si le voisin est vertical (même colonne)
        if neighbor.column == cell.column
          queue << [neighbor, distance + 1]
        end
      end
    end

    max_distance
  end

  def check_full_connectivity(grid)
    # Vérifie que toutes les cellules sont connectées
    # en calculant les distances depuis une cellule de départ
    start = grid[0, 0]
    distances = start.distances

    total_cells = grid.rows * grid.columns
    connected_cells = distances.cells.size

    # Si toutes les cellules ont une distance, le labyrinthe est connecté
    connected_cells == total_cells
  end

  def count_dead_ends(grid)
    count = 0
    grid.each_cell do |cell|
      count += 1 if cell.links.size == 1
    end
    count
  end

  def calculate_directional_bias(grid)
    total_links = 0
    horizontal_links = 0
    vertical_links = 0

    grid.each_cell do |cell|
      cell.links.each do |neighbor|
        total_links += 1
        if neighbor.row == cell.row
          horizontal_links += 1
        else
          vertical_links += 1
        end
      end
    end

    # Retourne le ratio (on divise par 2 car chaque lien est compté deux fois)
    total = total_links / 2.0
    {
      horizontal: total > 0 ? (horizontal_links / 2.0) / total : 0,
      vertical: total > 0 ? (vertical_links / 2.0) / total : 0
    }
  end
end

class MazeAnalyzer
  ALGORITHMS = {
    'Binary Tree' => BinaryTree,
    # 'Sidewinder' => Sidewinder
  }

  def initialize(rows: 10, cols: 10, samples: 10)
    @rows = rows
    @cols = cols
    @samples = samples
    @statistics = {}
  end

  def run
    puts "\n" + "ANALYSE DES ALGORITHMES DE GÉNÉRATION DE LABYRINTHES".center(70)
    puts "Paramètres: #{@rows}x#{@cols}, #{@samples} échantillons par algorithme\n"

    ALGORITHMS.each do |name, algorithm_class|
      stats = MazeStatistics.new(name)
      @statistics[name] = stats

      print "Génération de #{@samples} labyrinthes avec #{name}..."

      @samples.times do
        grid = Grid.new(@rows, @cols)

        generation_time = Benchmark.realtime do
          algorithm_class.on(grid)
        end

        stats.add_sample(grid, generation_time)
      end

      puts "\n"
      stats.print_summary
    end

    print_comparison
  end

  private

  def print_comparison
    puts "\n" + "COMPARAISON".center(70)
    puts "=" * 70

    fastest = @statistics.min_by { |_, stats| stats.average(stats.generation_times) }
    longest_path = @statistics.max_by { |_, stats| stats.average(stats.longest_paths) }
    most_dead_ends = @statistics.max_by { |_, stats| stats.average(stats.dead_ends) }
    longest_horizontal = @statistics.max_by { |_, stats| stats.average(stats.longest_horizontal_paths) }
    longest_vertical = @statistics.max_by { |_, stats| stats.average(stats.longest_vertical_paths) }

    puts sprintf("  %-35s: %s", "Plus rapide", fastest[0])
    puts sprintf("  %-35s: %s", "Plus long chemin en moyenne", longest_path[0])
    puts sprintf("  %-35s: %s", "Plus long chemin horizontal", longest_horizontal[0])
    puts sprintf("  %-35s: %s", "Plus long chemin vertical", longest_vertical[0])
    puts sprintf("  %-35s: %s", "Plus de culs-de-sac", most_dead_ends[0])

    puts "=" * 70
    puts ""
  end
end

# Lancer l'analyse si ce fichier est exécuté directement
if __FILE__ == $PROGRAM_NAME
  require_relative './cli'

  rows, cols = CLI.parse_rows_cols(ARGV, default_size: 10)
  samples = (ARGV[2] || 10).to_i

  analyzer = MazeAnalyzer.new(rows: rows, cols: cols, samples: samples)
  analyzer.run
end