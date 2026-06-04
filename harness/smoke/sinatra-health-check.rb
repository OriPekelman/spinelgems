require 'sinatra-health-check'

# --- Status basics ---
ok  = SinatraHealthCheck::Status.new(:ok,      'all good')
wrn = SinatraHealthCheck::Status.new(:warning, 'degraded', { hint: 'check logs' })
err = SinatraHealthCheck::Status.new(:error,   'down')

puts ok.level.inspect          # :ok
puts ok.severity               # 0
puts wrn.level.inspect         # :warning
puts wrn.severity              # 1
puts err.level.inspect         # :error
puts err.severity              # 2

h = wrn.to_h
puts h[:status]                # WARNING
puts h[:message]               # degraded
puts h[:hint].inspect          # :check_logs or "check logs"?  — key is :hint (symbol)

# --- StrictAggregator: worst wins ---
strict = SinatraHealthCheck::Status::StrictAggregator.new
agg = strict.aggregate(db: ok, cache: wrn)
puts agg.level.inspect         # :warning
puts agg.message               # at least one status is warning

# All OK case
agg_ok = strict.aggregate(db: ok)
puts agg_ok.level.inspect      # :ok
puts agg_ok.message            # everything is fine

# --- ForgivingAggregator: best wins ---
forgiving = SinatraHealthCheck::Status::ForgivingAggregator.new
agg_f = forgiving.aggregate(db: ok, cache: err)
puts agg_f.level.inspect       # :ok
puts agg_f.message             # everything is fine

# --- OverwritingAggregator: overwrite with explicit status ---
ow = SinatraHealthCheck::Status::OverwritingAggregator.new(strict)
# no overwrite — delegates to strict
agg_ow = ow.aggregate({ db: ok }, nil)
puts agg_ow.level.inspect      # :ok

# overwrite forces the given status
agg_force = ow.aggregate({ db: ok }, err)
puts agg_force.level.inspect   # :error
puts agg_force.message         # down

# --- Checker.status (no signals, no exit) ---
checker = SinatraHealthCheck::Checker.new(
  signals: [],
  exit:    false,
  systems: {
    db:    Struct.new(:status).new(ok),
    cache: Struct.new(:status).new(wrn),
  }
)
cs = checker.status
puts cs.level.inspect          # :warning
puts checker.healthy?          # true (healthy means level != :error; warning is still healthy)

# checker with only OK subsystems
checker_ok = SinatraHealthCheck::Checker.new(
  signals: [],
  exit:    false,
  systems: { db: Struct.new(:status).new(ok) }
)
puts checker_ok.healthy?       # true

# unhealthy flag overrides
checker_bad = SinatraHealthCheck::Checker.new(
  signals: [],
  exit:    false,
  health:  false,
  systems: { db: Struct.new(:status).new(ok) }
)
puts checker_bad.healthy?      # false (app marked unhealthy)
