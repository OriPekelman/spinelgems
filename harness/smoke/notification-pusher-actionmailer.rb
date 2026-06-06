# smoke: notification-pusher-actionmailer 4.0.1
#
# This gem is part of the notifications-rails suite.
# Its lib/ contains only notifications-rails.rb, which requires four
# sub-gems (notification-handler, notification-renderer, notification-pusher,
# notification-settings) — none of which are available standalone.
#
# There is no lib/notification-pusher-actionmailer.rb entry point and
# no implementation code in the gem itself.
#
# require 'notification-pusher-actionmailer' raises LoadError.
# require 'notifications-rails' immediately fails on notification-handler.
#
# The gem file structure is confirmed: lib/notifications-rails.rb (156 bytes).

puts "notification-pusher-actionmailer 4.0.1"
puts "type: meta-gem (notifications-rails suite)"
puts "entry: lib/notifications-rails.rb re-requires 4 Rails-only sub-gems"
puts "testable-code: none"
