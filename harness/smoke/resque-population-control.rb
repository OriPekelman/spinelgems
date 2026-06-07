require 'resque-population-control'

# Verify the version constant
puts Resque::Plugins::PopulationControl::VERSION

# Verify the exception class hierarchy
exc = Resque::Plugins::PopulationControl::PopulationExceeded.new("too many jobs")
puts exc.class
puts exc.is_a?(StandardError)
puts exc.message

# Build a fake Redis stub to exercise the module logic without a live Redis connection
class FakeRedis
  def initialize
    @store = {}
  end

  def incr(key)
    @store[key] = (@store[key] || 0) + 1
    @store[key]
  end

  def decr(key)
    @store[key] = (@store[key] || 0) - 1
    @store[key]
  end

  def get(key)
    @store[key].to_s
  end

  def set(key, val)
    @store[key] = val
  end

  def del(key)
    @store.delete(key)
  end
end

# Create a job class that extends PopulationControl
class MyJob
  extend Resque::Plugins::PopulationControl

  population_control 3

  def self.name
    "MyJob"
  end
end

# Wire up the fake redis
fake_redis = FakeRedis.new
Resque::Plugins::PopulationControl.redis = fake_redis

# Test population_control_max
puts MyJob.population_control_max

# Test cache key
puts MyJob.population_control_cache_key

# Test increment / count
MyJob.population_control_increment
MyJob.population_control_increment
puts MyJob.population_control_count

# Test population_controlled? (count 2 <= max 3 → true)
puts MyJob.population_controlled?

# Test max_population? (count 2 >= max 3 → false)
puts MyJob.max_population?

# Push to exactly the limit
MyJob.population_control_increment
puts MyJob.population_control_count
puts MyJob.max_population?

# Test before_enqueue raises PopulationExceeded when over limit
begin
  MyJob.before_enqueue_population_control("arg1")
rescue Resque::Plugins::PopulationControl::PopulationExceeded => e
  puts "caught: #{e.message}"
end

# Test decrement brings count back
MyJob.population_control_decrement
puts MyJob.population_control_count

# Test population_control_clear resets to nil/0
MyJob.population_control_clear
puts MyJob.population_control_count

# Test on_failure_population_control decrements (or floors at 0 via set)
MyJob.population_control_increment
MyJob.on_failure_population_control(RuntimeError.new("boom"))
puts MyJob.population_control_count
