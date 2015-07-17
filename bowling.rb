require "test/unit"

class Game
  def initialize()
      @pins = []
  end

  def throw(pins)
    @pins = @pins.push(pins)
  end

  def score
    allPins = Pins.new(0)

    if @pins.length == 0
      return allPins
    end

    for i in 0..@pins.length-1
      allPins.add(@pins[i])

      if i > 0 && (@pins[i].pins + @pins[i-1].pins == 10)
        allPins.add(@pins[i])
      end
    end

    return allPins
  end
end

class Pins
  attr_reader :pins

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
  
  def test_aSingleSpare
    game = Game.new()
    game.throw(Pins.new(9))
    game.throw(Pins.new(1))
    game.throw(Pins.new(1))
    assert_equal(Pins.new(9+1+1+1), game.score, "expected 1 bonus because of the spare")
  end
  
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
