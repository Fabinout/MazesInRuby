# frozen_string_literal: true
require_relative '../model/grid'

class AldousBroder
  def self.on(grid)
    cell = grid.random_cell
    unvisited = (grid.rows * grid.columns) - 1
    until unvisited.zero?
      neighbor = cell.neighbors.sample
      if neighbor.links.empty?
        cell.link(neighbor)
        unvisited -= 1
      end
      cell = neighbor
    end
  end
end
