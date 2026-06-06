require 'osaka'

# Exercise Osaka::Location — pure Ruby string-building, no AppleScript needed.

# Basic construction and to_s
loc = Osaka::Location.new("window \"Main\"")
puts loc.to_s

# as_prefixed_location
puts loc.as_prefixed_location

# Composition via +
button_loc = Osaka::Location.new("button \"OK\"")
composed = button_loc + loc
puts composed.to_s

# Building via fluent helpers from the top-level `at` helper
base = at
puts base.to_s.inspect                          # ""
puts base.window("Main").to_s
puts base.window("Main").button("OK").to_s
puts base.menu_bar(1).menu_bar_item("File").menu(1).menu_item("Save").to_s

# to_location_string: integer vs string
loc2 = Osaka::Location.new("")
puts loc2.to_location_string(42)
puts loc2.to_location_string("hello")

# has_element? predicates
win_loc = at.window("MyWin")
puts win_loc.has_window?
puts win_loc.has_menu_bar?

# top_level_element
puts win_loc.top_level_element.to_s

# Equality
puts (Osaka::Location.new("button \"A\"") == Osaka::Location.new("button \"A\""))
puts (Osaka::Location.new("button \"A\"") == Osaka::Location.new("button \"B\""))

# RemoteControl helper: construct_modifier_statement (pure string build)
rc = Osaka::RemoteControl.new("TestApp")
puts rc.construct_modifier_statement([:command, :shift]).strip
puts rc.construct_modifier_statement([]).inspect

# mac version classification (pure case/when, no system call)
puts rc.mac_version_string_to_name("10.8.5")
puts rc.mac_version_string_to_name("10.11.6")
puts rc.mac_version_string_to_name("14.0")
