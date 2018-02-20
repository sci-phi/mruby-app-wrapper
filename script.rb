begin
  ruby_vers_str = RUBY_ENGINE_VERSION # Not Supported before Ruby 2.x
rescue StandardError
  ruby_vers_str = RUBY_VERSION
end

puts "Hello. You ran this script with #{RUBY_ENGINE} #{ruby_vers_str}."
