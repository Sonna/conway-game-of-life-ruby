require "test_helper"

class GameTest < Minitest::Test
  # rubocop:disable Metrics/LineLength, Metrics/MethodLength
  def test_game_render_barren_board
    subject = local_io { ConwayGameOfLife::Game.new(80, 20, false).render }
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
      game = ConwayGameOfLife::Game.new(4, 4, false)
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
      game = ConwayGameOfLife::Game.new(6, 5, false)
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
      game = ConwayGameOfLife::Game.new(6, 6, false)
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
      game = ConwayGameOfLife::Game.new(5, 5, false)
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
      game = ConwayGameOfLife::Game.new(5, 5, false)
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
      game = ConwayGameOfLife::Game.new(5, 5, false)
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
      game = ConwayGameOfLife::Game.new(6, 6, false)
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
      game = ConwayGameOfLife::Game.new(6, 6, false)
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
      game = ConwayGameOfLife::Game.new(15, 15, false)
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
      game = ConwayGameOfLife::Game.new(9, 16, false)
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
      game = ConwayGameOfLife::Game.new(4, 4, false)
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
      game = ConwayGameOfLife::Game.new(7, 5, false)
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
