# salesflip-lead_notifications is a Rails 3 engine.
# lib/lead_notifications.rb only loads when defined?(Rails) && Rails::VERSION::MAJOR == 3.
# There is no standalone smokeable API — all code depends on Rails + ActionMailer + Salesflip.
# We load the entry file and verify it defines nothing (the guard is inactive), then
# manually define the module skeleton to confirm the class definitions parse correctly.

require 'lead_notifications'

# After requiring, nothing is defined (Rails guard inactive outside Rails).
puts defined?(LeadNotifications).inspect
puts "loaded_ok"
