require_relative "lib/remote_syslog"

puts RemoteSyslog::VERSION
puts RemoteSyslog::VERSION.class
puts RemoteSyslog::VERSION.split('.').length
puts RemoteSyslog::VERSION == "0.0.2"
