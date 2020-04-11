# frozen_string_literal: true

require_relative 'text_interface'
require_relative 'deck'
require_relative 'user'
require_relative 'dealer'
require_relative 'table'

class Gameplay
  include TextInterface

  attr_reader :user, :dealer, :table, :deck, :stop_error, :round
  
  def initialize   
    @dealer = Dealer.new('Dealer', 100)
    @table = Table.new('Table', 0)
    begin
      attempt ||= 0
      @stop_error = false
      username = new_username
      @user = User.new(username, 100)
    rescue RuntimeError => e
      if (attempt += 1) < 3
        puts e
        username_rule
        retry 
      else
        @stop_error = true
        return
      end
    end

    @deck = Deck.new()
  end

  def run_game
    welcome(@user.name)
    @round = 0
    continue = @deck.enough?(6)
    while continue
      unless run_round
        player_name = @dealer.bank?(10) ? @user.name : @dealer.name
        bank_is_over(player_name)
        break
      end

      break # temporary
      continue = @deck.enough?(6)
      unless continue
        deck_is_over
        game_is_over
      end
    end
    game_is_over
  end

  private

  def run_round
    return false unless place_bets
    @round += 1
    hand_out_first 
    show_interface
  end

  def place_bets
    return false unless @dealer.bank?(10) || @user.bank?(10)
    @dealer.give(10)
    @user.give(10)
    @table.take(20)
    true
  end


  def hand_out_first
    @deck.take_card(user)
    @deck.take_card(dealer)
    @deck.take_card(user)
    @deck.take_card(dealer)
  end

  def show_interface
    tiler
    @table.draw(round)
    @dealer.draw(false)
    @user.draw(true)
    gets # temporary
  end
end
