class Game
  HALF_A_SECOND = 0.5

  attr_reader :board

  def initialize(columns = Board::DEFAULT_COLUMNS,
                 rows = Board::DEFAULT_ROWS,
                 random = true)
    @board = Board.new(columns, rows, random)
  end

  def seed(input)
    board.seed(input)
  end

  def render
    puts board.render + "\n\n"
  end

  def run
    loop do
      render
      sleep(HALF_A_SECOND)
      $stdout.flush
      update
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
    num_alive = board.neighbours(col_i, row_i).count
    cell = board[row_i, col_i]
    # case board.neighbours(col_i, row_i).count
    # when 3 then cell.dead? && next_board[row_i, col_i].alive!
    # when 0..1 then next_board[row_i, col_i].dead!
    # when 2..3 then next_board[row_i, col_i].alive!
    # when 4..8 then next_board[row_i, col_i].dead!
    # end
    if (num_alive == 3 && cell.dead?) then next_board[row_i, col_i].alive!
    elsif (cell.alive?)
      # if (num_alive == 2 || num_alive == 3) then next_board[row_i, col_i].alive!
      # if (num_alive < 2) then next_board[row_i, col_i].dead!
      # elsif ((2..3).cover?(num_alive)) then next_board[row_i, col_i].alive!
      # elsif (num_alive > 4) then next_board[row_i, col_i].dead!
      # end
      case num_alive
      when 0..1 then next_board[row_i, col_i].dead!
      when 2..3 then next_board[row_i, col_i].alive!
      when 4..8 then next_board[row_i, col_i].dead!
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__ && ARGV.first == "run"
  game = Game.new
  if ARGV.length > 1
    game.seed(ARGV[1])
  end
  game.run
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

  class GameTest < Minitest::Test
    # rubocop:disable Metrics/LineLength, Metrics/MethodLength
    def test_game_render_barren_board
      subject = local_io { Game.new(80, 20, false).render }
      assert_equal(<<~BOARD + "\n", subject)
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

    # rubocop:disable Metrics/LineLength, Metrics/MethodLength
    class StillLifesGameTest < Minitest::Test
      def test_block_still_life
        game = Game.new(4, 4, false)
        game.seed(<<~BOARD)
          ....
          .**.
          .**.
          ....
        BOARD

        subject = local_io do
          game.update
          game.render
        end

        assert_equal(<<~BOARD + "\n", subject)
          ....
          .**.
          .**.
          ....
        BOARD
      end

      def test_beehive_still_life
        game = Game.new(6, 5, false)
        game.seed(<<~BOARD)
          ......
          ..**..
          .*..*.
          ..**..
          ......
        BOARD

        subject = local_io do
          game.update
          game.render
        end

        assert_equal(<<~BOARD + "\n", subject)
          ......
          ..**..
          .*..*.
          ..**..
          ......
        BOARD
      end

      def test_loaf_still_life
        game = Game.new(6, 6, false)
        game.seed(<<~BOARD)
          ......
          ..**..
          .*..*.
          ..*.*.
          ...*..
          ......
        BOARD

        subject = local_io do
          game.update
          game.render
        end

        assert_equal(<<~BOARD + "\n", subject)
          ......
          ..**..
          .*..*.
          ..*.*.
          ...*..
          ......
        BOARD
      end

      def test_boat_still_life
        game = Game.new(5, 5, false)
        game.seed(<<~BOARD)
          .....
          .**..
          .*.*.
          ..*..
          .....
        BOARD

        subject = local_io do
          game.update
          game.render
        end

        assert_equal(<<~BOARD + "\n", subject)
          .....
          .**..
          .*.*.
          ..*..
          .....
        BOARD
      end

      def test_tub_still_life
        game = Game.new(5, 5, false)
        game.seed(<<~BOARD)
          .....
          ..*..
          .*.*.
          ..*..
          .....
        BOARD

        subject = local_io do
          game.update
          game.render
        end

        assert_equal(<<~BOARD + "\n", subject)
          .....
          ..*..
          .*.*.
          ..*..
          .....
        BOARD
      end
    end

    class OscillatorsGameTest < Minitest::Test
      def test_blinker_oscillator
        game = Game.new(5, 5, false)
        game.seed(<<~BOARD)
          .....
          .....
          .***.
          .....
          .....
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .....
          ..*..
          ..*..
          ..*..
          .....
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .....
          .....
          .***.
          .....
          .....
        BOARD
      end

      def test_toad_oscillator
        game = Game.new(6, 6, false)
        game.seed(<<~BOARD)
          ......
          ......
          ..***.
          .***..
          ......
          ......
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ......
          ...*..
          .*..*.
          .*..*.
          ..*...
          ......
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ......
          ......
          ..***.
          .***..
          ......
          ......
        BOARD
      end

      def test_beacon_oscillator
        game = Game.new(6, 6, false)
        game.seed(<<~BOARD)
          ......
          .**...
          .**...
          ...**.
          ...**.
          ......
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ......
          .**...
          .*....
          ....*.
          ...**.
          ......
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ......
          .**...
          .**...
          ...**.
          ...**.
          ......
        BOARD
      end

      def test_pulsar_oscillator
        game = Game.new(15, 15, false)
        game.seed(<<~BOARD)
          ...............
          ...***...***...
          ...............
          .*....*.*....*.
          .*....*.*....*.
          .*....*.*....*.
          ...***...***...
          ...............
          ...***...***...
          .*....*.*....*.
          .*....*.*....*.
          .*....*.*....*.
          ...............
          ...***...***...
          ...............
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ....*.....*....
          ....*.....*....
          ....**...**....
          ...............
          ***..**.**..***
          ..*.*.*.*.*.*..
          ....**...**....
          ...............
          ....**...**....
          ..*.*.*.*.*.*..
          ***..**.**..***
          ...............
          ....**...**....
          ....*.....*....
          ....*.....*....
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ...............
          ...**.....**...
          ....**...**....
          .*..*.*.*.*..*.
          .***.**.**.***.
          ..*.*.*.*.*.*..
          ...***...***...
          ...............
          ...***...***...
          ..*.*.*.*.*.*..
          .***.**.**.***.
          .*..*.*.*.*..*.
          ....**...**....
          ...**.....**...
          ...............
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ...............
          ...***...***...
          ...............
          .*....*.*....*.
          .*....*.*....*.
          .*....*.*....*.
          ...***...***...
          ...............
          ...***...***...
          .*....*.*....*.
          .*....*.*....*.
          .*....*.*....*.
          ...............
          ...***...***...
          ...............
        BOARD
      end

      def test_pentadecathlon_oscillator
        game = Game.new(9, 16, false)
        game.seed(<<~BOARD)
          .........
          .........
          .........
          .........
          ...***...
          ...*.*...
          ...***...
          ...***...
          ...***...
          ...***...
          ...*.*...
          ...***...
          .........
          .........
          .........
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          .........
          .........
          ....*....
          ...*.*...
          ..*...*..
          ..*...*..
          ..*...*..
          ..*...*..
          ..*...*..
          ..*...*..
          ...*.*...
          ....*....
          .........
          .........
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          .........
          .........
          ....*....
          ...***...
          ..**.**..
          .***.***.
          .***.***.
          .***.***.
          .***.***.
          ..**.**..
          ...***...
          ....*....
          .........
          .........
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          .........
          .........
          ...***...
          ..*...*..
          .*.....*.
          .........
          *.......*
          *.......*
          .........
          .*.....*.
          ..*...*..
          ...***...
          .........
          .........
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          .........
          ....*....
          ...***...
          ..*****..
          .........
          .........
          .........
          .........
          .........
          .........
          ..*****..
          ...***...
          ....*....
          .........
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          .........
          ...***...
          ..*...*..
          ..*...*..
          ...***...
          .........
          .........
          .........
          .........
          ...***...
          ..*...*..
          ..*...*..
          ...***...
          .........
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          ....*....
          ...***...
          ..*.*.*..
          ..*.*.*..
          ...***...
          ....*....
          .........
          .........
          ....*....
          ...***...
          ..*.*.*..
          ..*.*.*..
          ...***...
          ....*....
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          ...***...
          .........
          ..*...*..
          ..*...*..
          .........
          ...***...
          .........
          .........
          ...***...
          .........
          ..*...*..
          ..*...*..
          .........
          ...***...
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ....*....
          ....*....
          ...***...
          .........
          .........
          ...***...
          ....*....
          ....*....
          ....*....
          ....*....
          ...***...
          .........
          .........
          ...***...
          ....*....
          ....*....
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          .........
          ...***...
          ....*....
          ....*....
          ...***...
          .........
          ...***...
          ...***...
          .........
          ...***...
          ....*....
          ....*....
          ...***...
          .........
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          ....*....
          ...***...
          .........
          .........
          ...***...
          .........
          ...*.*...
          ...*.*...
          .........
          ...***...
          .........
          .........
          ...***...
          ....*....
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          ...***...
          ...***...
          ....*....
          ....*....
          ....*....
          ...*.*...
          .........
          .........
          ...*.*...
          ....*....
          ....*....
          ....*....
          ...***...
          ...***...
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ....*....
          ...*.*...
          .........
          .........
          ...***...
          ...***...
          ....*....
          .........
          .........
          ....*....
          ...***...
          ...***...
          .........
          .........
          ...*.*...
          ....*....
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ....*....
          ....*....
          .........
          ....*....
          ...*.*...
          .........
          ...***...
          .........
          .........
          ...***...
          .........
          ...*.*...
          ....*....
          .........
          ....*....
          ....*....
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          .........
          .........
          ....*....
          ....*....
          ...*.*...
          ....*....
          ....*....
          ....*....
          ....*....
          ...*.*...
          ....*....
          ....*....
          .........
          .........
          .........
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .........
          .........
          .........
          .........
          ...***...
          ...*.*...
          ...***...
          ...***...
          ...***...
          ...***...
          ...*.*...
          ...***...
          .........
          .........
          .........
          .........
        BOARD
      end
    end
    # rubocop:enable Metrics/LineLength, Metrics/MethodLength

    # rubocop:disable Metrics/LineLength, Metrics/MethodLength
    class SpaceShipsGameTest < Minitest::Test
      def test_glider_spaceship
        game = Game.new(4, 4, false)
        game.seed(<<~BOARD)
          .*..
          ..*.
          ***.
          ....
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ....
          *.*.
          .**.
          .*..
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ....
          ..*.
          *.*.
          .**.
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ....
          .*..
          ..**
          .**.
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ....
          ..*.
          ...*
          .***
        BOARD
      end

      def test_lightweight_spaceship_spaceship
        game = Game.new(7, 5, false)
        game.seed(<<~BOARD)
          .**....
          ****...
          **.**..
          ..**...
          .......
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          *..*...
          ....*..
          *...*..
          .****..
          .......
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .......
          ...**..
          .**.**.
          .****..
          ..**...
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          .......
          ..****.
          .*...*.
          .....*.
          .*..*..
        BOARD

        subject = local_io { game.update; game.render; }
        assert_equal(<<~BOARD + "\n", subject)
          ...**..
          ..****.
          ..**.**
          ....**.
          .......
        BOARD
      end
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

# >> Run options: --seed 53645
# >>
# >> # Running:
# >>
# >> ......................
# >>
# >> Finished in 0.033987s, 647.3063 runs/s, 1529.9968 assertions/s.
# >>
# >> 22 runs, 52 assertions, 0 failures, 0 errors, 0 skips
