require "test/unit"

class Game
  def initialize()
    @frames = []
    @currentFrame = Frame.new()
  end

  def throw(pins)
    if @currentFrame.throwOne.nil? &&
        pins.isStrike == false
      @currentFrame.throwOne = pins
      @frames.push(@currentFrame)
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
      allPins.add(Pins.new(@frames[i].total))

      if i > 0 && @frames[i-1].total == 10
        allPins.add(@frames[i].throwOne)
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
