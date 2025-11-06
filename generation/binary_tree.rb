# frozen_string_literal: true

class BinaryTree

  def self.on(grid)
    grid.each_cell do |cell|
      cell.link(cell.north)
    end
    grid
  end
end
