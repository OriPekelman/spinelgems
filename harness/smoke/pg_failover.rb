# frozen_string_literal: true

require 'pg_failover'

# --- Config defaults ---
cfg = PgFailover::Config.new
puts cfg.throttle_interval    # default 10.0
puts cfg.max_retries          # default 1
puts cfg.throttle_enabled?    # true (interval > 0)
puts cfg.enabled?             # false (env var not set)

# --- Throttle: new connection is never throttled ---
throttle = PgFailover::Throttle.new(throttle_interval: 5.0)
puts throttle.throttle_interval  # 5.0
puts throttle.size               # 0
puts throttle.should_throttle?(:conn1).inspect  # nil (unknown)
puts throttle.known?(:conn1).nil?       # true

# Record a successful check
throttle.on_stale(:conn1) { true }
puts throttle.size               # 1
puts throttle.known?(:conn1).nil?  # false (has timestamp)
# Immediately after → should throttle (within 5s window)
puts throttle.should_throttle?(:conn1)  # true

# --- ConnectionValidator: no-op path when not in recovery ---
cfg2 = PgFailover::Config.new
cfg2[:throttle_interval] = 0.0   # disable throttle so call goes straight through
cfg2[:max_retries] = 2
require 'logger'
cfg2[:logger] = Logger.new(File::NULL)  # silence INFO/WARN to keep output deterministic

# Simulate: db is NOT in recovery
calls = 0
validator = PgFailover::ConnectionValidator.new(cfg2)
result = validator.call(
  in_recovery: -> { false },
  reconnect:   -> { calls += 1 },
  throttle_by: :conn_a
)
puts result   # true  (not in recovery → valid connection)
puts calls    # 0     (no reconnect attempts needed)

# Simulate: db IS in recovery, exhausts retries
calls2 = 0
validator2 = PgFailover::ConnectionValidator.new(cfg2)
result2 = validator2.call(
  in_recovery: -> { true },
  reconnect:   -> { calls2 += 1 },
  throttle_by: :conn_b
)
puts result2  # false (still in recovery after retries)
puts calls2   # 2     (max_retries = 2)
