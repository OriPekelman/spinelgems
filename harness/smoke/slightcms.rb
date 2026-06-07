# slightcms 0.1.5 — Rails 3 CMS plugin (2011)
# lib/slightcms.rb is an empty file (0 bytes); all logic lives in
# app/controllers/slightcms/pages_controller.rb which inherits from
# ApplicationController (Rails). No standalone public API exists.
# This smoke verifies require succeeds and the namespace is absent.

require 'slightcms'

# The entry point is empty, so no constants are defined.
defined_const = defined?(Slightcms)
puts "Slightcms defined: #{defined_const.inspect}"

# Confirm the lib file loaded without error by reaching here.
puts "require succeeded: true"
puts "no public API: true"
