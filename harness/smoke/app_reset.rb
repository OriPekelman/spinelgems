# smoke: app_reset
# Pure Rails Railtie gem — all logic (db-reset Rake task) requires Rails+Rake+ActiveRecord.
# We exercise the module constant and verify Rails integration code is not loaded without Rails.

require 'app_reset'
require 'app_reset/version'

puts AppReset::VERSION
puts AppReset.is_a?(Module)
# Railtie must NOT be defined when Rails is absent
puts defined?(AppReset::Railtie).inspect
# Module should have no extra public methods
puts AppReset.respond_to?(:new)
