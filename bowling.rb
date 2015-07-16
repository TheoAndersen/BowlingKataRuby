require "test/unit"

class Game
  def initialize()
  end

  def throw(pins)
    if @score.nil?
      @score = Score.new(pins)
    else
      @score.add(Score.new(pins))
    end
  end

  def score
    return @score
  end
end

class Score
  protected
  attr_reader :pins

  public
  def initialize(pins)
    @pins = pins
  end

  def ==(otherScore)
    @pins == otherScore.pins
  end

  def add(otherScore)
    @pins += otherScore.pins
  end
end

class BowlingTest < Test::Unit::TestCase
  def test_aGameOfOnly1s
    game = Game.new()
    20.times do
      game.throw(1)
    end
    assert_equal(Score.new(20), game.score)
  end
  
  def test_canThrowAPin
    game = Game.new()
    game.throw(1)
    assert_equal(Score.new(1), game.score)
  end
end
