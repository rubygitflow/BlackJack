# frozen_string_literal: true

require_relative 'validation'
require_relative 'card'
require_relative 'hand'
require_relative 'text_interface'

class Player
  include Validation

  attr_reader :name, :hand, :bank, :text_interface
  NAME_FORMAT = /^[a-zа-я]/i.freeze

  @@players = []

  validate :name, :presence
  validate :name, :unique, @@players
  validate :name, :name_format, NAME_FORMAT, 2

  def initialize(name, bank)
    @text_interface = TextInterface.new
    @name = name
    validate!

    @bank = bank
    @hand = Hand.new
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

  def draw(as_face)
    print format('%10s   ', @name)
    @text_interface.draw_bank(@bank)
    print ' ' * 3
    if as_face
      print " #{@hand.draw_face}   "
      @text_interface.draw_points(@hand.points)
    else
      print " #{@hand.draw_back}"
    end
    print "\n"
  end
end
