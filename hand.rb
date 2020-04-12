# frozen_string_literal: true

require_relative 'card'

class Hand < Array
  attr_reader :points

  def initialize
    @points = 0
  end

  def take_card(card, is_ace = false)
    if is_ace
      self << card
    else
      insert(0, card)
    end
    count_points
  end

  def give_card
    pull_out = shift
    count_points
    pull_out
  end

  def draw_face
    output = ''
    self.each { |card| output += ' | ' + card.fase }
    output += ' |'
  end

  def draw_back
    output = ''
    self.each { |card| output += ' | ' + card.back }
    output += ' |'
  end

  protected

  def count_points
    @points = 0
    self.each { |card| @points += card.value(@points) }
  end
end