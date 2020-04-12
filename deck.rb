# frozen_string_literal: true

require_relative 'card'
require_relative 'player'

class Deck
  attr_reader :current_deck

  def initialize
    generate_deck
    shuffle_deck
  end

  def generate_deck
    @current_deck = []
    Card::CARD_RANK.each do |rank|
      Card::CARD_SUIT.each do |suit|
        card = Card.new(rank, suit)
        @current_deck << card
      end
    end
  end

  def shuffle_deck
    current_deck.shuffle!
  end

  def put_card(player)
    return false if current_deck.empty?

    card = current_deck.pop
    player.hand.take_card(card, card.ace?)
    true
  end

  def enough?(amount)
    current_deck.length >= amount
  end
end
