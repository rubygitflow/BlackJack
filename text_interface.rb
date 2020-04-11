# frozen_string_literal: true

module TextInterface
    
  def new_username
    print 'Please enter your name: '
    gets.chomp
  end
      
  def username_rule
    puts 'Please use only letters for your name'
  end
      
  def welcome(name)
    puts "#{name}, welcome to Black Jack! Let's play!"
  end

  def deck_is_over
    puts "The deck is over"
  end

  def game_is_over
    puts "Game over. Goodbye!"
  end

  def bank_is_over(name)
    puts "#{name}'s bank is over."
  end

  def draw_round(round)
    print "Round #{round}."
  end

  def draw_bet(amount)
    print "Bet: #{amount}"
  end

  def draw_bank(amount)
    print "Bank: #{amount}"
  end

  def draw_points(points)
    print "Points: #{points}"
  end

  def tiler
    puts "_" * 43
  end
end
