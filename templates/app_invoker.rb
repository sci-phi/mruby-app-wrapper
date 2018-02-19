# app_invoker.rb is concatenated last after all lib sources have been collated
#
# The concatenated "lib" code must define an App object with six class methods:
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
#
# TODO: enforce_interface?

def show_version
  puts "#{App.name} (Version: #{App.version})"
end

def show_usage
  show_version
  App.usage_options
  puts "--usage (--help) : Show this usage information"
  puts "--version (-v) : Show the version information"
end

def invoke!(argv)
  # puts "DEBUG | invoke! | ARGV : #{argv.inspect}"
  if argv.nil? || argv.empty?
    App.default_action
  elsif argv.include?("--usage") || argv.include?("--help")
    show_usage
  elsif argv.include?("--version") || argv.include?("-v")
    show_version
  else
    # Defer all custom behaviour to App#invoke
    App.invoke(argv)
  end
end

# Clean Arguments:
# ARGV from C wrapper includes file name as first item, unlike 'mruby app.rb'...
#   EX: "./c-wrapper some-path --some-flag"
#         ARGV => ['./c-wrapper', 'some-path', '--some-flag']
# ARGV from mRuby excludes the overhead, first argument is first logical item
#   EX: "mruby app-script.rb some-path --some-flag"
#         ARGV => ['some-path', '--some-flag']
# Normalize the arguments so that wrapped code gets the same arguments
def clean_args(argv)
  # puts "DEBUG | clean_args | ARGV : #{argv.inspect}"
  # HACK: drop the first element from ARGV if command-like or script-like
  return nil if argv.nil? || argv.empty?
  return argv[1..-1] if argv[0] == App.command
  return argv[1..-1] if argv[0][-3..-1] == '.rb' # (m)ruby app.rb
  argv
end

# Invoke the app entry point with cleaned argument list
invoke!(clean_args(ARGV))

# print newline after last output
puts ""
# *** FINAL EXIT ***
