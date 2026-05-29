# Smoke test for resque-lonely_job
# Tests the LOCK_TIMEOUT constant defined in the main file (not version.rb)

puts Resque::Plugins::LonelyJob::LOCK_TIMEOUT

# Test that redis_key works (pure string formatting with @queue ivar)
class TestWorker
  extend Resque::Plugins::LonelyJob
  @queue = :critical
end
puts TestWorker.redis_key
