# frozen_string_literal: true

class Cell
  attr_reader :row, :column, :grid
  attr_accessor :north, :east, :south, :west

  def initialize(row, column, grid)
    @row = row
    @column = column
    @grid = grid
    @links = {}
  end

  def link(cell, bidi = true, notify = true)
    return self unless cell
    @links[cell] = true
    if bidi
      cell.link(self, false)
      grid.notify_cells_linked(self, cell) if notify
    end
    self
  end

  def unlink(cell, bidi = true)
    @links.delete(cell)
    cell.unlink(self, false) if bidi
  end

  def links
    @links.keys
  end

  def linked?(cell)
    @links.key?(cell)
  end

  def neighbors
    list = []
    list << north if north
    list << east if east
    list << south if south
    list << west if west
    list.compact
  end
end