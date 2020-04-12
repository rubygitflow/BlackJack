# frozen_string_literal: true

require_relative 'card'
require_relative 'player'

class Deck
  attr_reader :current_deck
  CARD_RANK = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  CARD_SUIT = %w[♢ ♣ ♡ ♠].freeze

  def initialize
    @current_deck = generate_deck
    shuffle_deck
  end

  def generate_deck
    @current_deck = []
    CARD_RANK.each do |rank|
      CARD_SUIT.each do |suit|
        card = Card.new(rank, suit)
        @current_deck << card
      end
    end
    current_deck
  end

  def shuffle_deck
    current_deck.shuffle!
  end

  def take_card(player)
    return false if current_deck.empty?

    card = current_deck.pop
    player.take_card(card, card.ace?)
    true
  end

  def enough?(amount)
    current_deck.length >= amount
  end
end
