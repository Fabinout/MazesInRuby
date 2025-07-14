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
        Cell.new(row, col)
      end
    end

    # Configuration des cellules voisines
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        cell.north = @grid[r-1][c] if r > 0
        cell.south = @grid[r+1][c] if r + 1 < rows
        cell.west = @grid[r][c-1] if c > 0
        cell.east = @grid[r][c+1] if c + 1 < columns
      end
    end
  end

  def cell_at(row, column)
    @grid[row][column]
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
end