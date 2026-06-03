# Smoke test for redlock gem (v0.1.1)
# Uses testing modes (:bypass, :fail) to exercise real logic without Redis.
# A minimal Redis stub is injected via $LOAD_PATH so that `require 'redis'`
# in redlock.rb resolves to our no-op class (works under both CRuby and Spinel).
$LOAD_PATH.unshift('/tmp/redlock_smoke_stub')

require 'redlock'

# 1. Constants
puts Redlock::VERSION
puts Redlock::DEFAULT_RETRY_COUNT
puts Redlock::DEFAULT_RETRY_DELAY
puts Redlock::CLOCK_DRIFT_FACTOR

# 2. Build an instance with no server URLs (avoids Redis.new calls; quorum=1)
lock_client = Redlock.new

# 3. set_retry — mutates internal state
lock_client.set_retry(5, 100)
puts "set_retry ok"

# 4. testing=:bypass — lock returns a valid info hash without any Redis
lock_client.testing = :bypass
result = lock_client.lock("my-resource", 10_000, "fixed-val-abc")
puts result[:resource]
puts result[:val]
puts result[:validity]

# 5. testing=:fail — lock returns false (pass explicit val to avoid SecureRandom)
lock_client.testing = :fail
result2 = lock_client.lock("my-resource", 10_000, "fixed-val-xyz")
puts result2.inspect

# 6. unlock in bypass mode is a no-op (returns nil)
lock_client.testing = :bypass
fake_lock = { resource: "my-resource", val: "fixed-val-abc" }
ret = lock_client.unlock(fake_lock)
puts ret.inspect

# 7. UNLOCK_SCRIPT constant — verify it contains the Redis Lua logic
puts Redlock::UNLOCK_SCRIPT.include?("redis.call")
