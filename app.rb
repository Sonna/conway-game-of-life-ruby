class Cell
  def initialize(alive = (rand.round == 0))
    @alive = alive
  end

  def ==(other)
    self.class == other.class && self.alive? == other.alive?
  end

  def alive!
    @alive = true
  end

  def alive?
    @alive
  end

  def dead!
    @alive = false
  end

  def dead?
    !alive?
  end

  def render
    alive? ? "*" : "."
  end
end

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

class Game
  HALF_A_SECOND = 0.5

  attr_reader :board

  def initialize(random = true)
    @board = Board.new(Board::DEFAULT_COLUMNS, Board::DEFAULT_ROWS, random)
  end

  def render
    puts board.render + "\n"
  end

  def run
    loop do
      update
      render
      sleep(HALF_A_SECOND)
      $stdout.flush
    end
  end

  def update
    next_board = Board.new(board.columns, board.rows, false)
    board.cells.each do |col_index, row|
      row.each do |row_index, _cell|
        update_cell(next_board, col_index, row_index)
      end
    end
    @board = next_board
  end

  def update_cell(next_board, col_i, row_i)
    case board.neighbours(col_i, row_i).count
    when 3 && board[row_i, col_i].dead? then next_board[row_i, col_i].alive!
    when 0..1 then next_board[row_i, col_i].dead!
    when 2..3 then next_board[row_i, col_i].alive!
    when 4..8 then next_board[row_i, col_i].dead!
    end
  end
end

if $PROGRAM_NAME == __FILE__ && ARGV.first == "run"
  Game.new.run
elsif $PROGRAM_NAME == __FILE__ ||
  ($PROGRAM_NAME == __FILE__ && ARGV.first == "test")
  require "minitest/autorun"

  def local_io(in_str = "")
    old_stdin = $stdin
    old_stdout = $stdout
    $stdin = StringIO.new(in_str)
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdin = old_stdin
    $stdout = old_stdout
  end

  class CellTest < Minitest::Test
    def test_alive_is_boolean
      subject = Cell.new
      assert !!subject.alive? == subject.alive?
    end

    def test_alive_not_random
      subject = Cell.new(true)
      assert subject.alive?
      refute subject.dead?
    end

    def test_dead_not_random
      subject = Cell.new(false)
      assert subject.dead?
      refute subject.alive?
    end

    def test_alive!
      subject = Cell.new(false)
      assert subject.dead?
      subject.alive!
      assert subject.alive?
    end

    def test_dead!
      subject = Cell.new(true)
      assert subject.alive?
      subject.dead!
      assert subject.dead?
    end
  end

  class BoardTest < Minitest::Test
    def test_board_constuction
      subject = Board.new(2, 3, false)
      assert_equal subject.cells, {
        0 => { 0 => Cell.new(false), 1 => Cell.new(false) },
        1 => { 0 => Cell.new(false), 1 => Cell.new(false) },
        2 => { 0 => Cell.new(false), 1 => Cell.new(false) }
      }
    end

    def test_board_element_reference
      subject = Board.new(2, 1, false)
      (0...subject.rows).include?(0) # => true
      (0...subject.columns).include?(1) # => true
      assert_equal subject.cells, {
        0 => { 0 => Cell.new(false), 1 => Cell.new(false) }
      }
      assert_equal subject[1, 0], Cell.new(false)
      # eh? this is not much of a valid test
    end

    # rubocop:disable Metrics/MethodLength
    def test_board_cells_when_seeded
      subject = Board.new(3, 3, false)
      subject.seed(<<~BOARD)
        .*.
        *.*
        .*.
      BOARD
      assert_equal subject.cells, {
        0 => { 0 => Cell.new(false), 1 => Cell.new(true), 2 => Cell.new(false) },
        1 => { 0 => Cell.new(true), 1 => Cell.new(false), 2 => Cell.new(true) },
        2 => { 0 => Cell.new(false), 1 => Cell.new(true), 2 => Cell.new(false) }
      }
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def test_board_render_when_seeded
      subject = Board.new(3, 3, false)
      subject.seed(<<~BOARD)
        .*.
        ***
        .*.
      BOARD
      assert_equal(<<~BOARD.strip, subject.render)
        .*.
        ***
        .*.
      BOARD
    end
    # rubocop:enable Metrics/MethodLength
  end

  class GameTest < Minitest::Test
    # rubocop:disable Metrics/LineLength, Metrics/MethodLength
    def test_game_render_barren_board
      subject = local_io { Game.new(false).render }
      assert_equal(<<~BOARD, subject)
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
        ................................................................................
      BOARD
    end
    # rubocop:enable Metrics/LineLength, Metrics/MethodLength
  end
end

# == References:
# - [typechecking \- Check if Ruby object is a Boolean \- Stack Overflow]
#   (https://stackoverflow.com/questions/3028243/check-if-ruby-object-is-a-boolean)
#
# - [Ruby Language: Simple Flip\-a\-coin Application]
#   (http://rubylanguage.blogspot.com.au/2012/08/simple-flip-coin-application.html)
#

# >> Run options: --seed 40163
# >>
# >> # Running:
# >>
# >> ..........
# >>
# >> Finished in 0.003619s, 2763.1943 runs/s, 4144.7914 assertions/s.
# >>
# >> 10 runs, 15 assertions, 0 failures, 0 errors, 0 skips
