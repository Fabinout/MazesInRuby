class GridCreatedEvent < MazeEvent
  attr_reader :rows, :columns

  def initialize(rows, columns)
    super()
    @rows = rows
    @columns = columns
  end

  def apply(maze)
    maze.create_grid(@rows, @columns)
  end

  def to_h
    super.merge(rows: @rows, columns: @columns)
  end
end

class CellCreatedEvent < MazeEvent
  attr_reader :row, :column

  def initialize(row, column)
    super()
    @row = row
    @column = column
  end

  def apply(maze)
    # maze.add_cell(@row, @column)
  end

  def to_h
    super.merge(row: @row, column: @column)
  end
end

class CellsLinkedEvent < MazeEvent
  attr_reader :from_row, :from_column, :to_row, :to_column

  def initialize(from_row, from_column, to_row, to_column)
    super()
    @from_row = from_row
    @from_column = from_column
    @to_row = to_row
    @to_column = to_column
  end

  def apply(maze)
    cell1 = maze.cell_at(@from_row, @from_column)
    cell2 = maze.cell_at(@to_row, @to_column)
    cell1.link(cell2, true, false)
  end

  def to_h
    super.merge(
      from_row: @from_row,
      from_column: @from_column,
      to_row: @to_row,
      to_column: @to_column
    )
  end
end
