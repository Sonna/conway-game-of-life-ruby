require "test_helper"

class BoardTest < Minitest::Test
  def test_board_constuction
    subject = ConwayGameOfLife::Board.new(2, 3, false)
    assert_equal subject.cells, {
      0 => { 0 => cell.new(false), 1 => cell.new(false) },
      1 => { 0 => cell.new(false), 1 => cell.new(false) },
      2 => { 0 => cell.new(false), 1 => cell.new(false) }
    }
  end

  def test_board_element_reference
    subject = ConwayGameOfLife::Board.new(2, 1, false)
    (0...subject.rows).include?(0) # => true
    (0...subject.columns).include?(1) # => true
    assert_equal subject.cells, {
      0 => { 0 => cell.new(false), 1 => cell.new(false) }
    }
    assert_equal subject[1, 0], cell.new(false)
    # eh? this is not much of a valid test
  end

  # rubocop:disable Metrics/MethodLength
  def test_board_cells_when_seeded
    subject = ConwayGameOfLife::Board.new(3, 3, false)
    subject.seed(<<~BOARD)
      .*.
      *.*
      .*.
    BOARD
    assert_equal subject.cells, {
      0 => { 0 => cell.new(false), 1 => cell.new(true), 2 => cell.new(false) },
      1 => { 0 => cell.new(true), 1 => cell.new(false), 2 => cell.new(true) },
      2 => { 0 => cell.new(false), 1 => cell.new(true), 2 => cell.new(false) }
    }
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def test_board_render_when_seeded
    subject = ConwayGameOfLife::Board.new(3, 3, false)
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

  private

  def cell
    ConwayGameOfLife::Cell
  end
end
