require 'observer'

# Exercise the Observable module: add_observer, delete_observer,
# count_observers, changed, changed?, notify_observers

class EventSource
  include Observable

  def emit(value)
    changed
    notify_observers(value)
  end
end

class Collector
  attr_reader :received

  def initialize
    @received = []
  end

  def update(value)
    @received << value
  end
end

src = EventSource.new

# Initially no observers, not changed
puts src.count_observers   # => 0
puts src.changed?          # => false

c1 = Collector.new
c2 = Collector.new

src.add_observer(c1)
src.add_observer(c2)
puts src.count_observers   # => 2

# Emit without calling changed first — no notifications
src.notify_observers(99)
puts c1.received.length    # => 0

# Emit via the helper that calls changed + notify_observers
src.emit(10)
src.emit(20)

puts c1.received.inspect   # => [10, 20]
puts c2.received.inspect   # => [10, 20]

# After notify_observers, changed? resets to false
src.changed
puts src.changed?          # => true
src.notify_observers(:ping)
puts src.changed?          # => false

# delete one observer
src.delete_observer(c2)
puts src.count_observers   # => 1

src.emit(30)
puts c1.received.inspect   # => [10, 20, 30]
puts c2.received.inspect   # => [10, 20]  (c2 stopped receiving)

# delete_observers clears all
src.delete_observers
puts src.count_observers   # => 0
