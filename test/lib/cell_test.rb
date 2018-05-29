require "test_helper"

class CellTest < Minitest::Test
  def test_alive_is_boolean
    subject = ConwayGameOfLife::Cell.new
    assert !!subject.alive? == subject.alive?
  end

  def test_alive_not_random
    subject = ConwayGameOfLife::Cell.new(true)
    assert subject.alive?
    refute subject.dead?
  end

  def test_dead_not_random
    subject = ConwayGameOfLife::Cell.new(false)
    assert subject.dead?
    refute subject.alive?
  end

  def test_alive!
    subject = ConwayGameOfLife::Cell.new(false)
    assert subject.dead?
    subject.alive!
    assert subject.alive?
  end

  def test_dead!
    subject = ConwayGameOfLife::Cell.new(true)
    assert subject.alive?
    subject.dead!
    assert subject.dead?
  end
end
