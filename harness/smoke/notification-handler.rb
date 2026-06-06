# smoke: notification-handler 4.0.1
# This gem's only file is lib/notifications-rails.rb which requires 'notification-handler'
# (itself), making it impossible to load standalone. This is a broken gem package.
# We attempt require to confirm the LoadError and document the smoke-error.

begin
  require 'notification-handler'
  puts "UNEXPECTED: require succeeded"
rescue LoadError => e
  puts "LoadError: #{e.message}"
rescue => e
  puts "Error: #{e.class}: #{e.message}"
end
