# frozen_string_literal: true

class Card
  CARD_RANK = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  CARD_SUIT = %w[♢ ♣ ♡ ♠].freeze

  attr_reader :rank, :fase

  def initialize(rank, suit)
    @rank = rank
    to_string = rank + suit
    @fase = '%3s' % to_string
  end

  def back
    '***'
  end

  def ace?
    rank == 'A'
  end

  def value(points = 0)
    case rank
    when '2'..'9'
      rank.to_i
    when '10', 'J', 'Q', 'K'
      10
    when 'A'
      if points + 11 > 21
        1
      else
        11
      end
    else
      0
    end
  end
end
