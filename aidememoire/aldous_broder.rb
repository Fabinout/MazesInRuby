# frozen_string_literal: true
require_relative '../model/grid'

class AldousBroder
  def self.on(grid)
    cell = grid.random_cell
    unvisited = (grid.rows * grid.columns) - 1

    while unvisited > 0
      neighbor = cell.neighbors.sample

      if neighbor.links.empty?
        cell.link(neighbor)
        unvisited -= 1
      end

      cell = neighbor
    end
    grid
  end
end