require_relative 'maze_event_base'
require_relative 'maze_event_handlers'
require_relative 'cell'
require 'json'

class Grid
  attr_reader :rows, :columns, :events

  def initialize(rows, columns)
    @events = []
    apply_event(GridCreatedEvent.new(rows, columns))
  end

  private def apply_event(event)
    @events << event
    event.apply(self)
  end

  def create_grid(rows, columns)
    @rows = rows
    @columns = columns
    @grid = Array.new(rows) do |row|
      Array.new(columns) do |col|
        Cell.new(row, col, self)
      end
    end

    # Configuration des cellules voisines
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        cell.north = @grid[r - 1][c] if r > 0
        cell.south = @grid[r + 1][c] if r + 1 < rows
        cell.west = @grid[r][c - 1] if c > 0
        cell.east = @grid[r][c + 1] if c + 1 < columns
      end
    end
  end

  def cell_at(row, column)
    @grid[row][column]
  end

  def [](row, column)
    return nil unless row.between?(0, @rows - 1)
    return nil unless column.between?(0, @grid[row].count - 1)
    @grid[row][column]
  end

  def notify_cells_linked(cell1, cell2)
    apply_event(CellsLinkedEvent.new(cell1.row, cell1.column, cell2.row, cell2.column))
  end

  def link_cells(from_row, from_column, to_row, to_column)
    apply_event(CellsLinkedEvent.new(from_row, from_column, to_row, to_column))
  end

  def each_cell
    @grid.each do |row|
      row.each do |cell|
        yield cell
      end
    end
  end

  def each_row
    @grid.each do |row|
      yield row
    end
  end

  def save_events(filename)
    File.write(filename, JSON.pretty_generate(@events.map(&:to_h)))
  end

  def self.replay_from_file(filename)
    events = JSON.parse(File.read(filename))
    grid = nil

    events.each do |event_data|
      event = case event_data['type']
              when 'GridCreatedEvent'
                grid = new(event_data['rows'], event_data['columns'])
              when 'CellsLinkedEvent'
                grid.link_cells(
                  event_data['from_row'],
                  event_data['from_column'],
                  event_data['to_row'],
                  event_data['to_column']
                )
              end
    end
    grid
  end

  # Valeur par défaut pour le rendu d’une cellule (peut être surchargée)
  def contents_of(cell)
    " "
  end

  # Rendu ASCII de la grille
  def to_s
    output = "+" + ("---+" * columns) + "\n"
    @grid.each do |row|
      top = "|"
      bottom = "+"

      row.each do |cell|
        cell = Cell.new(-1, -1, self) unless cell
        body = " #{contents_of(cell)} "
        east_boundary = (cell.linked?(cell.east) ? " " : "|")
        south_boundary = (cell.linked?(cell.south) ? "   " : "---")
        top << body << east_boundary
        bottom << south_boundary << "+"
      end

      output << top << "\n"
      output << bottom << "\n"
    end
    output
  end
end

