require 'test-unit-notify'

# VERSION
puts Test::Unit::Notify::VERSION

# GrowlnotifyForWindows::URGENCIES hash with default
urgencies = Test::Unit::Notify::GrowlnotifyForWindows::URGENCIES
puts urgencies["critical"]   # => 2
puts urgencies["normal"]     # => 0 (default)
puts urgencies["unknown"]    # => 0 (default)

# NotifyCommand subclass: check availability via PATH lookup
ns = Test::Unit::Notify::NotifySend.new
puts ns.available?.class   # => TrueClass or FalseClass (Boolean)

gn = Test::Unit::Notify::Growlnotify.new
puts gn.available?         # => false on Linux without growlnotify

# Notifier class-level available? and command detection
puts Test::Unit::Notify::Notifier.available?  # true (notify-send present)
cmd = Test::Unit::Notify::Notifier.command
puts cmd.class.name   # Test::Unit::Notify::NotifySend (or nil)

# Notify module enable/disable toggles
Test::Unit::Notify.enable
puts Test::Unit::Notify.enabled?   # => true
Test::Unit::Notify.disable
puts Test::Unit::Notify.enabled?   # => false

# ICON_DIR is a Pathname built at load time
icon_dir = Test::Unit::Notify::Notifier::ICON_DIR
puts icon_dir.class   # => Pathname
puts icon_dir.basename.to_s   # => "icons"
