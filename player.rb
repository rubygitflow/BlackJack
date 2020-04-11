# frozen_string_literal: true

require_relative 'validation'
require_relative 'card'
require_relative 'text_interface'

class Player
  include Validation
  include TextInterface

  attr_accessor :name, :hand, :bank, :points
  NAME_FORMAT = /^[a-zа-я]/i.freeze

  @@players = []

  validate :name, :presence
  validate :name, :unique, @@players
  validate :name, :name_format, NAME_FORMAT, 2

  def initialize(name, bank)
    @name = name
    validate!

    @bank = bank
    @hand = []
    @points = 0
    @@players << name
  end

  def take(amount)
    @bank += amount
  end

  def give(amount)
    @bank -= amount
  end

  def bank?(amount)
    @bank >= amount
  end

  def take_card(card, is_ace)
    if is_ace
      @hand << card
    else
      @hand.insert(0, card)
    end
  end

  def draw(as_face)
    if as_face
      print "%10s   " % @name
      draw_bank(@bank)
      print "  "
      print " #{draw_hand_face}   "
      draw_points(count_points)
      print "\n"
    else
      print "%10s   " % @name
      draw_bank(@bank)
      print "  "
      print " #{draw_hand_back} "
      print "\n"
    end
  end

  private

  def draw_hand_face
    output = ''
    @hand.each{ |card| output += ' | ' + card.fase }
    output += ' |'
  end

  def draw_hand_back
    output = ''
    @hand.each{ |card| output += ' | ' + card.back }
    output += ' |'
  end

  def count_points
    @points = 0
    @hand.each{ |card| @points += card.value(@points) }
    @points
  end
end
