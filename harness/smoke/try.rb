require 'try_until'

# Smoke test for try-until gem
# Tests: Probe, Repeatedly, NullPrinter, stop_when, rescues, configuration

include TryUntil

# 1. Probe#to_s describes itself
arr = [10, 20, 30]
probe = Probe.new(arr, :length)
puts probe.to_s

# 2. Probe#sample calls the method on the target
puts probe.sample

# 3. Probe with args
arr2 = [1, 2, 3, 4, 5]
probe2 = Probe.new(arr2, :first, [2])
puts probe2.sample.inspect

# 4. Probe with hash args (single-hash path)
hash_target = { a: 1, b: 2 }
probe3 = Probe.new(hash_target, :fetch, { a: 99 })
# When args is a Hash, it passes @args directly (not splat)
# hash_target.fetch({a: 99}) would raise KeyError — use a key that exists
probe4 = Probe.new(hash_target, :fetch, :a)
puts probe4.sample

# 5. Repeatedly: condition met on first attempt
counter = [0]
inc_probe = Probe.new(counter, :first)
result = Repeatedly.new(inc_probe)
  .attempts(5)
  .interval(0)
  .delay(0)
  .stop_when(lambda { |v| v == 0 })
  .execute
puts result

# 6. Repeatedly: condition met after N attempts (mutating state)
state = { count: 0 }
class StateCounter
  def initialize(state) = @state = state
  def tick
    @state[:count] += 1
    @state[:count]
  end
end

sc = StateCounter.new(state)
sc_probe = Probe.new(sc, :tick)
result2 = Repeatedly.new(sc_probe)
  .attempts(5)
  .interval(0)
  .stop_when(lambda { |v| v == 3 })
  .execute
puts result2
puts state[:count]

# 7. Repeatedly#configuration keys
cfg = Repeatedly.new(probe).configuration
puts cfg.keys.sort.inspect

# 8. Rescues: rescue a known error and eventually succeed
fail_count = [0]
flaky = Object.new
flaky.define_singleton_method(:call) do
  fail_count[0] += 1
  raise ArgumentError, "not yet" if fail_count[0] < 3
  "success"
end
flaky_probe = Probe.new(flaky, :call)
result3 = Repeatedly.new(flaky_probe)
  .attempts(5)
  .interval(0)
  .rescues([ArgumentError])
  .stop_when(lambda { |v| v == "success" })
  .execute
puts result3
puts fail_count[0]

# 9. NullPrinter swallows output silently
np = NullPrinter.new
np.printf("should not print %s\n", "anything")
puts "null_printer ok"
