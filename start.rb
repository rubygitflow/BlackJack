# frozen_string_literal: true

require_relative 'gameplay'

game = Gameplay.new
exit if game.stop_error
game.run_game
