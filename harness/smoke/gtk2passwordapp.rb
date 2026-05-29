puts Gtk2PasswordApp::VERSION
puts Gtk2PasswordApp::HELP.lines.first.strip
puts Gtk2PasswordApp::HELP.include?('--nogui')
puts Gtk2PasswordApp::HELP.include?('--version')
puts Gtk2PasswordApp::VERSION.split('.').length
