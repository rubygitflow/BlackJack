# frozen_string_literal: true

require_relative 'validation'

class Player
  include Validation

  attr_accessor :name, :hand, :bank, :points
  NAME_FORMAT = /^[a-zа-я]/i.freeze

  validate :name, :presence
  validate :name, :name_format, NAME_FORMAT, 2

  def initialize(name)
    @name = name
    validate!

    @bank = 100
    @hand = []
    @points = 0
  end

end
