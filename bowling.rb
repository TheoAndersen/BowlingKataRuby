require "test/unit"



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

  def isStrike()
    return pins == 10
  end
end

class Frame
  attr_accessor :throwOne, :throwTwo

  def total()
    totalValue = 0
    
    if @throwOne.nil? && @throwTwo.nil?
      return 0
    end

    if @throwOne.nil? == false
      totalValue += @throwOne.pins
    end

    if @throwTwo.nil? == false
      totalValue += @throwTwo.pins
    end
    
    return totalValue
  end
end

class Game
  attr_reader :frames
  
  def initialize()
    @frames = []
    @currentFrame = Frame.new()
  end

  def throw(pins)
    if @currentFrame.throwOne.nil?
      @currentFrame.throwOne = pins
      @frames.push(@currentFrame)

      if pins.isStrike()
        @currentFrame = Frame.new()
      end
    else
      @currentFrame.throwTwo = pins
      @currentFrame = Frame.new()
    end
  end

  def score
    allPins = Pins.new(0)

    if @frames.length == 0
      return allPins
    end

    for i in 0..@frames.length-1
      if i < 10
        allPins.add(Pins.new(@frames[i].total))
      end

      if i > 0 && i < 11 && @frames[i-1].total == 10
        if @frames[i-1].throwOne.isStrike()
          allPins.add(Pins.new(@frames[i].total))
        else
          allPins.add(@frames[i].throwOne)
        end
      end

      if i > 1 &&
          @frames[i-2].throwOne.isStrike() &&
          @frames[i-1].throwOne.isStrike()
        allPins.add(@frames[i].throwOne)
      end
    end

    return allPins
  end
end


class BowlingTest < Test::Unit::TestCase

  def test_APerfectGame
    game = Game.new()
    12.times do
      game.throw(Pins.new(10))
    end
    assert_equal(Pins.new(300), game.score, "a perfect game should give another strike")
  end
  
  def test_AStrike
    game = Game.new()
    game.throw(Pins.new(10))
    game.throw(Pins.new(1))
    game.throw(Pins.new(1))
    assert_equal(Pins.new(10+2+2), game.score, "expected 2 bonus because of the strike")
  end
  
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

  def test_frameCanCalculateTotalScore
    assert_equal(0, newFrame(nil, nil).total)
    assert_equal(1, newFrame(Pins.new(1), nil).total)
    assert_equal(1, newFrame(nil, Pins.new(1)).total)
    assert_equal(2, newFrame(Pins.new(1), Pins.new(1)).total)
  end

  def newFrame(throwOne, throwTwo)
    frame = Frame.new()
    frame.throwOne = throwOne
    frame.throwTwo = throwTwo
    return frame
  end

end
