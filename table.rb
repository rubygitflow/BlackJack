# frozen_string_literal: true

require_relative 'player'
require_relative 'text_interface'

class Table < Player
  include TextInterface

  def initialize(name, bank)
    super(name, bank)
  end

  def bet
  	@bank
  end

  def shield
  	@hand
  end

  def draw(round, active_player)
  	draw_round(round)
  	print "   "
  	draw_bet(@bank)
  	print "   "
  	draw_player(active_player)
  	print "\n"
  end
end
