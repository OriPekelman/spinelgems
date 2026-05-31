puts SafeTimeout.is_a?(Module)
puts SafeTimeout.respond_to?(:timeout)
puts SafeTimeout.respond_to?(:send_signal)
puts SafeTimeout.instance_methods(false).sort.inspect
