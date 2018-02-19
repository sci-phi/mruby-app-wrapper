#!/usr/bin/env ruby

# frozen_string_literal: true

require 'fileutils'

# MRUBY INSTALL CONFIGURATION
MRUBY_VERSION = "1.3.0"
MRUBY_GZ_URL = "https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz"
MRUBY_ROOT_DIR = "/usr/local/mruby"

unless File.writable?(MRUBY_ROOT_DIR)
  puts ""
  puts "The target folder should be owned (writable) by user"
  puts "    '#{MRUBY_ROOT_DIR}'"
  puts ""
  puts "To remedy this, issue the following commands manually:"
  puts "    'sudo mkdir -p /usr/local/mruby'"
  puts "    'sudo chown $(whoami) /usr/local/mruby'"
  puts ""
  puts "And then re-run this script."
  puts ""
  raise "Permissions Error on '#{MRUBY_ROOT_DIR}'"
end

unless File.directory?(MRUBY_ROOT_DIR)
  FileUtils.mkdir_p(MRUBY_ROOT_DIR)
end

`cd #{MRUBY_ROOT_DIR} && curl -LO #{MRUBY_GZ_URL}`
ARCHIVE_NAME = "#{MRUBY_VERSION}.tar.gz"
MRUBY_ARCHIVE_PATH = File.join(MRUBY_ROOT_DIR, ARCHIVE_NAME)
raise "Downlod Failed" unless File.file?(MRUBY_ARCHIVE_PATH)

`cd #{MRUBY_ROOT_DIR} && tar -xvf #{ARCHIVE_NAME}`
MRUBY_UNTAR_PATH = File.join(MRUBY_ROOT_DIR, "mruby-#{MRUBY_VERSION}")
raise "Extract Failed" unless File.directory?(MRUBY_UNTAR_PATH)

`cd #{MRUBY_ROOT_DIR} && mv mruby-#{MRUBY_VERSION} #{MRUBY_VERSION}`
MRUBY_VERS_PATH = File.join(MRUBY_ROOT_DIR, MRUBY_VERSION)
raise "Install Failed" unless File.directory?(MRUBY_VERS_PATH)

# UPDATE MRUBY CONFIG
# ====================
# Replace gembox :
#   conf.gembox 'default'
#   => conf.gembox 'dockerized'

MRUBY_CFG_PATH = File.join(MRUBY_VERS_PATH, "build_config.rb")

line_set = []
File.open(MRUBY_CFG_PATH, 'r') do |f|
  f.readlines.each do |line|
    line_set << line
    if line =~ /conf.gembox/
      supplement = line.sub('default', 'dockerized')
      puts "Supplement: #{supplement}"
      line_set << supplement
    end
  end
end

# Write the replacement lines over the current build config
File.open(MRUBY_CFG_PATH, "w") { |f| f.puts line_set.join }

# INSTALL GEMBOX
TEMPLATE = File.join(File.dirname(__FILE__), 'templates', 'dockerized.gembox')
GEMBOX_PATH = File.join(MRUBY_VERS_PATH, 'mrbgems', 'dockerized.gembox')

FileUtils.cp(TEMPLATE, GEMBOX_PATH)
raise "Gembox Failed" unless File.file?(GEMBOX_PATH)

# BUILD MRUBY
`cd #{MRUBY_VERS_PATH} && ruby ./minirake clean && ruby ./minirake`

MRUBY_BIN_PATH = File.join(MRUBY_VERS_PATH, "bin")
MRUBY_BIN_MAIN = File.join(MRUBY_BIN_PATH, "mruby")
MRUBY_BIN_BYTE = File.join(MRUBY_BIN_PATH, "mrbc")
raise "Failed" unless File.file?(MRUBY_BIN_MAIN) && File.file?(MRUBY_BIN_BYTE)

puts "Add '#{MRUBY_BIN_PATH}' to your PATH."
puts "EXAMPLE: export PATH=$PATH:#{MRUBY_BIN_PATH}"
