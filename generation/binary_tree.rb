# frozen_string_literal: true

class BinaryTree

  def self.on(grid)
    grid.each_cell do |cell|
      neighbor = [cell.north, cell.east].compact.sample
      cell.link(neighbor)
    end
    grid
  end
end
