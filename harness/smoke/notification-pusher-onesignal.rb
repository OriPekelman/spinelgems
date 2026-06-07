# frozen_string_literal: true

# notification-pusher-onesignal 4.0.1 contains no actual Ruby code.
# Its only lib file is lib/notifications-rails.rb (mispackaged from the parent
# notifications-rails meta-gem), which immediately requires other gems
# (notification-handler, notification-renderer, etc.) that are not bundled.
# There is no lib/notification-pusher-onesignal.rb entry point at all.
# require 'notification-pusher-onesignal' raises LoadError under plain CRuby.

require 'notification-pusher-onesignal'
