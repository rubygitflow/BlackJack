# frozen_string_literal: true

require_relative 'text_interface'
require_relative 'deck'
require_relative 'user'
require_relative 'dealer'
require_relative 'table'

class Gameplay
  include TextInterface

  attr_reader :user, :dealer, :table, :deck, :stop_error, :round, :user_move
  attr_reader :stop_game, :next_round

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

    @deck = Deck.new
    @stop_game = false
    @next_round = false
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
    @next_round = false
    @user_move = true
    hand_out_first
    show_interface
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
    @table.draw(round, active_player)
    @dealer.draw(false)
    @user.draw(true)
    show_player_dialog
  end

  def active_player
    @user_move ? @user.name : @dealer.name
  end

  def show_player_dialog
    if @user_move
      player_choice = offer_user_choice(@user.hand.length == 3)
    else
      offer_dealer_choice
      player_choice = make_dealer_choice
      puts player_choice
    end
    check_player_choice(player_choice)
  end

  def make_dealer_choice
    if @dealer.count_points < 17
      if @dealer.hand.length < 3
        2
      else
        1
      end
    else
      1
    end
  end

  def check_player_choice(player_choice)
    if @user_move
      @user_move = !@user_move # strictly inside the condition
      case player_choice
      when 1
        show_interface
      when 2
        @deck.take_card(user)
        show_interface
      end
    else
      @user_move = !@user_move # strictly inside the condition
      @deck.take_card(dealer) if player_choice == 2
      show_interface
    end
    return if @stop_game
    return if @next_round

    check_round
    show_user_dialog
  end

  def check_round
    bet = @table.bank
    @table.give(bet)
    user_points = @user.count_points
    dealer_points = @dealer.count_points
    if user_points > 21
      if dealer_points < 22
        @dealer.take(bet)
      else
        tie = (bet / 2).round
        @dealer.take(tie)
        @user.take(tie)
      end
    elsif user_points < dealer_points
      if dealer_points < 22
        @dealer.take(bet)
      else
        @user.take(bet)
      end
    elsif user_points == dealer_points
      tie = (bet / 2).round
      @dealer.take(tie)
      @user.take(tie)
    else
      @user.take(bet)
    end
  end

  def show_user_dialog
    tiler
    @table.draw(round, '')
    @dealer.draw(true)
    @user.draw(true)
    case offer_next_round_or_finish_game
    when 1
      @next_round = true
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
    until card.nil?
      @table.take_card(card)
      card = player.give_card
    end
  end
end
