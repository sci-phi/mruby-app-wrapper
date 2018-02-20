# frozen_string_literal: true

# World Tour
class WorldTour

  attr_reader :headliner, :location, :shows

  def initialize(shows, headliner)
    @location = 'Practice Space' # You oughtta practice before you go on tour...
    @toured = []
    @shows = shows
    @headliner = headliner
  end

  def perform
    puts ""
    puts "Much Excite. Very w0w! #{headliner.name} are going on a World Tour!!!"
    puts ""
    sleep 5
    shows.each do |show|
      travel(show)
      @toured = headliner.perform(show)
    end
  end

  private

  def travel(city)
    puts ""
    puts "Load up the #{transpo}, on the way from #{location} to #{city}."
    puts ""
    sleep 3
    @location = city
  end

  def transpo
    %w[bus plane train van].sample
  end

end
