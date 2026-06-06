# smoke: notification-settings 4.0.1
# This gem (notifications-rails meta-gem) has only lib/notifications-rails.rb
# which requires notification-handler, notification-renderer, notification-pusher,
# and notification-settings — all separate gems not cached here.
# There is no self-contained Ruby logic to exercise.

begin
  require 'notifications-rails'
rescue LoadError => e
  puts "LoadError: #{e.message}"
end

puts "smoke-error: no self-contained code in notification-settings meta-gem"
