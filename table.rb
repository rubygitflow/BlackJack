# frozen_string_literal: true

require_relative 'player'

class Table < Player

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
    @text_interface.draw_round(round)
    print ' ' * 3
    @text_interface.draw_bet(@bank)
    print ' ' * 3
    @text_interface.draw_player(active_player)
    print "\n"
  end
end
