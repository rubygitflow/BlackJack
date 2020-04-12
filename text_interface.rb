# frozen_string_literal: true

module TextInterface
    
  def new_username
    print 'Please enter your name: '
    gets.chomp.capitalize
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
    print "Bank: %3s" % amount
  end

  def draw_points(points)
    print "Points: #{points}"
  end

  def tiler
    puts "_" * 43
  end

  def offer_next_round_or_finish_game
    print "1 - next round;"
    print "   "
    print "2 - finish game"
    print "\n"
    input = gets.chomp.to_i
    if [1, 2].include?(input)
      return input
    end
    offer_next_round_or_finish_game
  end

  def offer_user_choice
    print "1 - Pass;"
    print "   "
    print "2 - Add card;"
    print "   "
    print "3 - Open the hand"
    print "\n"
    input = gets.chomp.to_i
    if [1, 2, 3].include?(input)
      return input
    end
    offer_user_choice
  end

  def offer_dealer_choice
    print "1 - Pass;"
    print "   "
    print "2 - Add card"
    print "\n"
    input = gets.chomp.to_i
    if [1, 2].include?(input)
      return input
    end
    offer_dealer_choice
  end

end
