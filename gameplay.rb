# frozen_string_literal: true

require_relative 'text_interface'
require_relative 'deck'
require_relative 'user'
require_relative 'dealer'
require_relative 'table'

class Gameplay

  attr_reader :user, :dealer, :table, :deck, :stop_error, :round, :user_move
  attr_reader :stop_game, :next_round, :text_interface

  def initialize
    @text_interface = TextInterface.new
    @dealer = Dealer.new('Dealer', 100)
    @table = Table.new('Table', 0)
    begin
      attempt ||= 0
      @stop_error = false
      username = @text_interface.new_username
      @user = User.new(username, 100)
    rescue RuntimeError => e
      if (attempt += 1) < 3
        puts e
        @text_interface.username_rule
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
    @text_interface.welcome(@user.name)
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
      @text_interface.deck_is_over unless @deck.enough?(6)
    end
    @text_interface.game_is_over
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
    @deck.put_card(user)
    @deck.put_card(dealer)
    @deck.put_card(user)
    @deck.put_card(dealer)
  end

  def show_interface
    @text_interface.tiler
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
      player_choice = @text_interface.offer_user_choice(@user.hand.length == 3)
    else
      @text_interface.offer_dealer_choice
      player_choice = make_dealer_choice
      puts player_choice
    end
    check_player_choice(player_choice)
  end

  def make_dealer_choice
    if @dealer.hand.points < 17
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
        @deck.put_card(user)
        show_interface
      end
    else
      @user_move = !@user_move # strictly inside the condition
      @deck.put_card(dealer) if player_choice == 2
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
    if @user.hand.points > 21
      if @dealer.hand.points < 22
        @dealer.take(bet)
      else
        tie = (bet / 2).round
        @dealer.take(tie)
        @user.take(tie)
      end
    elsif @user.hand.points < @dealer.hand.points
      if @dealer.hand.points < 22
        @dealer.take(bet)
      else
        @user.take(bet)
      end
    elsif @user.hand.points == @dealer.hand.points
      tie = (bet / 2).round
      @dealer.take(tie)
      @user.take(tie)
    else
      @user.take(bet)
    end
  end

  def show_user_dialog
    @text_interface.tiler
    @table.draw(round, '')
    @dealer.draw(true)
    @user.draw(true)
    case @text_interface.offer_next_round_or_finish_game
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
    card = player.hand.give_card
    until card.nil?
      @table.hand.take_card(card)
      card = player.hand.give_card
    end
  end
end
