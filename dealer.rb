# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  def initialize(name, bank)
    super(name, bank)
  end
end
