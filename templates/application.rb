# frozen_string_literal: true

# An example "App" with the required class methods called from app_invoker.rb
#
# name : returns the full name of the application (EX: "World Tour Simulator")
# command : returns the actual name of the executable (EX: "toursim")
# version : returns the string representation of the app version (EX: "0.0.1")
# usage_options : simple descriptions of how to use any application options
# default_action : performs this action when no arguments are given on CLI
#     NOTE: Expect to default to 'show_usage' if any ARGS are required
# invoke : takes an array of arguments from command line and performs actions
#
# All of the logic of the application should be triggered from the invoke method
#     so *most* customizations should be external to App class
#     except for adjustments to the (naive) option parsing in :invoke
#
class App

  def self.command
    "toursim"
  end

  def self.name
    "World Tour Simulator"
  end

  def self.version
    "0.0.2b"
  end

  def self.default_action
    # Convention: global 'show_usage' calls into 'App#usage_options'
    show_usage
  end

  def self.usage_options
    puts "#{command} <artist-name> [options]"
    puts ""
    puts "Options:"
    puts "--play (-p) : Play one random show"
    puts "--tour (-t) : Tour the World!"
  end

  def self.invoke(argv = [])
    puts "DEBUG | invoke! | ARGV : #{argv.inspect}"
    # Get the first item, the name of the band being simulated
    # NOTE: safe navigation operator ('&.') supported in Ruby 2.3+ & mRuby 1.3+
    artist_name = argv.reject { |g| g =~ /^-/ }&.first || "The Foo Fighters"

    performer = RockBand.new(name: artist_name)
    itinerary = %w[Santiago Sydney Niigata Golden\ City Hamburg Quebec Chicago]

    if argv.include?("--play") || argv.include?("-p")

      performer.perform(itinerary.sample)

    elsif argv.include?("--tour") || argv.include?("-t")

      tour = WorldTour.new(shows: itinerary, headliner: performer)
      tour.perform
    else
      default_action
    end
  end
end
