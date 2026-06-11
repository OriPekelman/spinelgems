# BlueShell smoke — exercises the timeout accessor defined inline in blue-shell.rb
puts BlueShell.timeout
BlueShell.timeout = 60
puts BlueShell.timeout
BlueShell.timeout = 5
puts BlueShell.timeout
BlueShell.timeout = 30
puts BlueShell.timeout
