# frozen_string_literal: true

require_relative 'text_interface'
require_relative 'deck'
require_relative 'user'
require_relative 'dealer'

class Gameplay
  include TextInterface

  attr_reader :user, :dealer, :deck, :stop_error
  
  def initialize   
    @dealer = Dealer.new('Dealer')
    begin
      attempt ||= 0
      @stop_error = false
      username = new_username
      @user = User.new(username)
    rescue RuntimeError => e
      if (attempt += 1) < 3
        puts e
        username_rule
        retry 
      else
        @stop_error = true
        return
      end
    end

  end

  def run_game
    welcome(@user.name)
  end
end
