# smoke: notification-renderer 4.0.1
#
# This gem is the "notifications-rails" meta/bundle gem.
# Its lib/ contains only notifications-rails.rb, which has
# four `require` calls to sub-gems (notification-handler,
# notification-renderer, notification-pusher, notification-settings).
# There is no implementation code in this gem itself.
#
# `require 'notification-renderer'` raises LoadError (no such file).
# `require 'notifications-rails'` immediately fails on the first
# sub-gem dependency (notification-handler), which is not installed.
#
# Nothing can be smoked: smoke-error.

puts "notification-renderer 4.0.1: meta-gem, no implementation"
puts "lib file: notifications-rails.rb (requires 4 sub-gems only)"
puts "smoke-error: no testable code"
