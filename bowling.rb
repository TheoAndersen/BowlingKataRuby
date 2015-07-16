require "test/unit"

class Game
  def initialize()
  end

  def throw(pins)
    if @score.nil?
      @score = pins
    else
      @score.add(pins)
    end
  end

  def score
    return @score
  end
end

class Pins
  protected
  attr_reader :pins

  public
  def initialize(pins)
    @pins = pins
  end

  def ==(otherPins)
    @pins == otherPins.pins
  end

  def add(otherPins)
    @pins += otherPins.pins
  end
end

class BowlingTest < Test::Unit::TestCase
  def test_aGameOfOnly1s
    game = Game.new()
    20.times do
      game.throw(Pins.new(1))
    end
    assert_equal(Pins.new(20), game.score)
  end
  
  def test_canThrowAPin
    game = Game.new()
    game.throw(Pins.new(1))
    assert_equal(Pins.new(1), game.score)
  end
end
