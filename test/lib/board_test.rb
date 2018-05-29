require "test_helper"

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
