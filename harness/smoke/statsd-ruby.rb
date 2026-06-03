require 'statsd_tcp'

# Stub network I/O: override connect and send_to_socket so real
# stat-formatting logic can be exercised without any socket.
class StatsdTcp
  def connect
    @socket = :stub
  end

  protected

  def send_to_socket(message)
    (@_sent ||= []) << message
    message.length
  end

  public

  def last_sent
    (@_sent ||= []).last
  end
end

s = StatsdTcp.new('localhost', 8125)

# namespace= sets @prefix
s.namespace = 'myapp'
puts s.namespace
puts s.prefix

# postfix= with value
s.postfix = 'prod'
puts s.postfix

# delimiter default and assignment
puts s.delimiter
s.delimiter = '-'
puts s.delimiter
s.delimiter = '.'

# Stat formatting: count
s.namespace = 'test'
s.postfix = nil
s.count('requests', 5)
puts s.last_sent

# increment (count=1)
s.increment('hits')
puts s.last_sent

# decrement (count=-1)
s.decrement('misses')
puts s.last_sent

# gauge
s.gauge('memory', 1024)
puts s.last_sent

# timing
s.timing('response', 42)
puts s.last_sent

# set
s.set('users', 7)
puts s.last_sent

# explicit count, no namespace
s.namespace = nil
s.count('explicit', 99, 1)
puts s.last_sent

# Ruby :: delimiter replacement (:: -> .)
s.increment('My::Module::Event')
puts s.last_sent

# MonotonicTime returns a positive numeric
ms = StatsdTcp::MonotonicTime.time_in_ms
puts ms > 0
puts ms.is_a?(Numeric)
