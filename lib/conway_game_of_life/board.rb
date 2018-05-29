class Board
  DEFAULT_COLUMNS = 80
  DEFAULT_ROWS = 20

  attr_reader :cells
  attr_reader :columns
  attr_reader :rows

  def initialize(columns = DEFAULT_COLUMNS, rows = DEFAULT_ROWS, random = true)
    @columns = columns
    @rows = rows
    @cells = Hash.new { |hash, key| hash[key] = Hash.new }
    columns.times do |col|
      rows.times do |row|
        cells[row][col] = random ? Cell.new : Cell.new(false)
      end
    end
  end

  def [](x, y)
    # maybe loop the board in the future?
    return nil unless (0...columns).include?(x) && (0...rows).include?(y)
    cells[y][x]
  end

  def neighbours(col_i, row_i)
    neighbouring_cells(col_i, row_i).compact.reject(&:dead?)
  end

  def neighbouring_cells(col_i, row_i)
    [
      self[row_i - 1, col_i - 1], # top_left
      self[row_i - 1, col_i],     # top_middle
      self[row_i - 1, col_i + 1], # top_right
      self[row_i, col_i - 1],     # middle_left
      self[row_i, col_i + 1],     # middle_right
      self[row_i + 1, col_i - 1], # bottom_left
      self[row_i + 1, col_i],     # bottom_middle
      self[row_i + 1, col_i + 1]  # bottom_right
    ] #.compact # remove nils
  end

  def render
    cells.values.map { |row| row.values.map(&:render).join }.join("\n")
  end

  # @param [String] input string to seed cells from text,
  #   where `*` a cell is alive, otherwise dead
  def seed(input)
    lines = input.split("\n")
    columns.times do |col|
      rows.times do |row|
        cells[row][col] = Cell.new(lines[row][col] == '*')
      end
    end
  end
end
