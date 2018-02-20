# frozen_string_literal: true

# Rake Build Configuration
require 'rake/clean'

desc 'Default: run tests'
task default: :test

# HELPER METHODS
# ===============
def abs_path(relative_path)
  File.join(File.dirname(__FILE__), relative_path)
end

# CONSTANTS FOR BUILDING EXECUTABLE APPS VIA MRUBY
# =================================================
EXE = "mruby-app"
MAIN_C = "app.c"
MRUBY_VERS_STR = "1.3.0"
APP_INVOKER_RB = abs_path("templates/app_invoker.rb")
CONCATENATED_RB_CODE = abs_path("build/current/concatenated_ruby_code.rb")
CURR_BUILD = abs_path("build/current")
BYTECODE_C = abs_path("build/current/concatenated_ruby_code.c")
TEMPLATE_C = abs_path("templates/mruby_wrapper.c")
APP_WRAPPER_C = abs_path("build/current/#{MAIN_C}")
TARGET_BINARY = File.join(CURR_BUILD, EXE)
BUILD_OS = `uname -s`.strip
DTS = `date -u +%Y%m%d_%H%M%S`.strip
ARCHIVE_NAME = "#{EXE}-#{BUILD_OS}-#{DTS}.tgz"
ARCHIVED_BUILD = File.join(CURR_BUILD, ARCHIVE_NAME)
if BUILD_OS == "Darwin"
  MRUBY_A = '/usr/local/mruby/1.3.0/build/host/lib/libmruby.a'
  MRUBY_I = '/usr/local/mruby/1.3.0/include/'
else
  # TODO: Redo sciphi/mruby-base to nest versioned folder deeper like Mac OS X
  MRUBY_A = "/usr/src/mruby-#{MRUBY_VERS_STR}/build/host/lib/libmruby.a"
  MRUBY_I = "/usr/src/mruby-#{MRUBY_VERS_STR}/include/"
end

# RAKE 'FILE' TASKS
# ==================
FileList['lib/*.rb'].each do |src|
  # REBUILD THE CONCATENATED FILE IF ANY OF THE INDIVIDUAL FILES CHANGE
  file CONCATENATED_RB_CODE => abs_path(src)
end

file CONCATENATED_RB_CODE => APP_INVOKER_RB do
  mkdir_p CURR_BUILD
  # COMBINE ALL THE RUBY LIB CODE INTO ONE CONCATENATED FILE
  `cat #{abs_path('lib')}/*.rb > #{CONCATENATED_RB_CODE}`
  # APPEND THE MAIN RUBY ENTRY POINT FROM ROOT OF PROJECT
  `cat #{APP_INVOKER_RB} >> #{CONCATENATED_RB_CODE}`
end

file APP_WRAPPER_C => TEMPLATE_C do
  mkdir_p CURR_BUILD
  # COPY THE C TEMPLATE FOR USE AS THE APP WRAPPER
  cp TEMPLATE_C, APP_WRAPPER_C
end

file BYTECODE_C => CONCATENATED_RB_CODE do
  command = "mrbc -Bconcatenatedrb concatenated_ruby_code.rb"
  # GENERATE APPLICATION BYTECODE FROM THE COMBINED RUBY CODE
  `cd #{CURR_BUILD} && #{command}`
end

file TARGET_BINARY => [BYTECODE_C, APP_WRAPPER_C] do
  # NOTE: Must append "-lstdc++" linker flag due to inclusion of TinyXML2 mgem
  command = \
    "gcc -std=c99 -I#{MRUBY_I} -I. #{MAIN_C} -o #{EXE} #{MRUBY_A} -lm -lstdc++"
  puts ""
  puts "GCC Command: '#{command}'"
  puts ""
  # COMPILE THE BINARY EXECUTABLE USING GCC TO EMBED BOTH MRUBY AND MRB BYTECODE
  `cd #{CURR_BUILD} && echo 'FOO' && #{command}`
end

file ARCHIVED_BUILD => [TARGET_BINARY] do
  command = "tar -zcvf #{ARCHIVE_NAME} #{EXE}"
  `cd #{CURR_BUILD} && #{command}`
end

# GENERATED INTERMEDIATE CODE THAT CAN BE FLUSHED AT WILL
CLEAN.include(CONCATENATED_RB_CODE, BYTECODE_C, APP_WRAPPER_C)
# GENERATED PRODUCT(S)
CLOBBER.include(TARGET_BINARY, ARCHIVED_BUILD)

# RAKE 'NAMED' TASKS
# ===================
desc "Archive the binary for distribution"
task archive: ARCHIVED_BUILD do
  puts "Archived the built binary."
end

desc "Build the binary executable"
task build: TARGET_BINARY do
  puts "Built the application as binary."
end

desc "Concatenate all the (m)Ruby code."
task concat: CONCATENATED_RB_CODE do
  puts "Concatenated all the (m)Ruby code."
end

desc "Release the binary executable"
task release: [TARGET_BINARY, ARCHIVED_BUILD] do
  version_str = `#{TARGET_BINARY} --version`
  clean_vers = version_str.split(' ').last[0..-2] # Drop trailing parentheses
  version_folder = File.join(abs_path('release'), clean_vers)
  mkdir_p version_folder
  released_path = File.join(version_folder, ARCHIVE_NAME)
  mv ARCHIVED_BUILD, released_path
end

desc "Check that the product is executable"
task check: TARGET_BINARY do
  # Test the binary produced...
  tool = File.join(CURR_BUILD, EXE)
  puts `#{tool} --usage`
end

desc "Test : Not Implemented Yet"
task :test do
  puts "'rake test'"
  puts "Tests are not implemented yet."
  puts "Please use 'rake -T' to list the other available tasks."
end
