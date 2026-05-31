puts CapybaraWatcher::Configuration.options[:timeout]
puts CapybaraWatcher::Configuration.options.class
puts CapybaraWatcher::Configuration.options.key?(:timeout)
CapybaraWatcher.configure { |cfg| cfg[:timeout] = 5 }
puts CapybaraWatcher::Configuration.options[:timeout]
