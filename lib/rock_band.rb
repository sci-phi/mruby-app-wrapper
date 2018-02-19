# frozen_string_literal: true

# Rock Band
class RockBand

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def perform(place = 'friends')
    welcome(place)

    performance = %w[Rock Roll].sample
    puts "#{performance}ing #{place}..."
    sleep 1

    puts "Thank you. Thank you, very much!"

    [place, "#{performance}ed"]
  end

  def welcome(place = 'friends')
    puts "Hello, #{place}! It's great to be here."
    puts "We are #{name}."
  end

end
