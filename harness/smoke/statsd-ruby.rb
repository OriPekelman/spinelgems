# Smoke: statsd-ruby — test pure string formatting without network
# Subclass Statsd to override connect/send_to_socket, avoiding actual sockets
class FakeStatsd < Statsd
  def initialize(host = '127.0.0.1', port = 8125)
    @host = host || '127.0.0.1'
    @port = port || 8125
    self.delimiter = "."
    @prefix = nil
    @batch_size = 10
    @batch_byte_size = nil
    @flush_interval = nil
    @postfix = nil
    @socket = nil
    @protocol = :udp
    @s_mu = Mutex.new
    @sent = []
    # do NOT call connect
  end

  def send_to_socket(message)
    @sent << message
  end

  def last_sent
    @sent.last
  end
end

sd = FakeStatsd.new('localhost', 8125)

# namespace= sets prefix
sd.namespace = 'myapp'
puts sd.namespace
puts sd.prefix

# postfix= sets @postfix
sd.postfix = 'prod'
puts sd.postfix

# delimiter
sd.delimiter = '-'
puts sd.delimiter

# reset delimiter
sd.delimiter = nil
puts sd.delimiter

# stat formatting via count (goes through send_stats -> send_to_socket)
sd2 = FakeStatsd.new
sd2.namespace = 'test'
sd2.count('requests', 5, 1)
puts sd2.last_sent

sd2.increment('hits')
puts sd2.last_sent

sd2.decrement('misses')
puts sd2.last_sent

sd2.gauge('memory', 1024)
puts sd2.last_sent

sd2.timing('response', 42)
puts sd2.last_sent
