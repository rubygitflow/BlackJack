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
    puts 'The deck is over'
  end

  def game_is_over
    puts 'Game over. Goodbye!'
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
    print 'Bank: %3s' % amount
  end

  def draw_player(active_player)
    print "Player: #{active_player}"
  end

  def draw_points(points)
    print "Points: #{points}"
  end

  def tiler
    puts '_' * 43
  end

  def offer_next_round_or_finish_game
    print '1 - next round;'
    print ' ' * 3
    print '2 - finish game'
    print "\n"
    input = gets.chomp.to_i
    return input if [1, 2].include?(input)

    offer_next_round_or_finish_game
  end

  def offer_user_choice(skip_card)
    print '1 - Pass;'
    print ' ' * 3
    unless skip_card
      print '2 - Add card;'
      print ' ' * 3
    end
    print '3 - Open the hand'
    print "\n"
    input = gets.chomp.to_i
    check_array = skip_card ? [1, 3] : [1, 2, 3]
    return input if check_array.include?(input)
    offer_user_choice(skip_card)
  end

  def offer_dealer_choice
    print '1 - Pass;'
    print ' ' * 3
    print '2 - Add card'
    print "\n"
  end
end
