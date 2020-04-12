# frozen_string_literal: true

require_relative 'text_interface'
require_relative 'deck'
require_relative 'user'
require_relative 'dealer'
require_relative 'table'

class Gameplay
  include TextInterface

  attr_reader :user, :dealer, :table, :deck, :stop_error, :round, :user_move, :stop_game
  
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
    @stop_game = false
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
      break if @stop_game
      finish_round
      continue = @deck.enough?(6)
      deck_is_over unless continue
    end
    game_is_over
  end

  private

  def run_round
    return false unless place_bets
    @round += 1
    @user_move = true
    hand_out_first 
    show_interface
    @user_move = !@user_move
    true
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
    show_player_dialog
  end

  def show_player_dialog
    if @user_move
      player_choice = offer_user_choice
    else
      player_choice = offer_dealer_choice
    end
    check_player_choice(player_choice)
  end

  def check_player_choice(player_choice)
    if @user_move
      case player_choice
      when 1
      when 2
      else
      end
    else
      case player_choice
      when 1
      else
      end
    end
    check_round
    show_user_dialog
  end

  def check_round
    bet = @table.bank
    @table.give(bet)
    user_points = @user.count_points
    dealer_points = @dealer.count_points
    if user_points > 21 || user_points < dealer_points
      @dealer.take(bet)
    elsif user_points == dealer_points
      tie = bet div 2
      @dealer.take(tie)
      @user.take(tie)
    else
      @user.take(bet)
    end
  end

  def show_user_dialog
    tiler
    @table.draw(round)
    @dealer.draw(true)
    @user.draw(true)
    user_choice = offer_next_round_or_finish_game
    case user_choice
    when 1
    else
      @stop_game = true
    end
  end

  def finish_round
    move_cards_to_table(@dealer)
    move_cards_to_table(@user)
  end

  def move_cards_to_table(player)
    card = player.give_card
    while !card.nil?
      @table.take_card(card)
      card = player.give_card
    end
  end
end
