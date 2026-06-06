# smoke: slyphon-log4j
# This gem is a JRuby-only wrapper shipping the log4j-1.2.15.jar.
# Under CRuby/Spinel, lib/log4j.rb attempts:
#   require File.expand_path('.../log4j-1.2.15.jar')
# which fails with LoadError on non-JRuby runtimes.
# The only accessible Ruby content is Log4j::VERSION.
# We load the version submodule directly (not the top-level) to at least
# exercise the module definition and constant lookup.
require 'log4j/version'

puts Log4j::VERSION
puts Log4j::VERSION.split('.').map(&:to_i).inspect
puts Log4j::VERSION =~ /\A\d+\.\d+/ ? "version-format:ok" : "version-format:bad"
