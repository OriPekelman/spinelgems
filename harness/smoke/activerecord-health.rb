# frozen_string_literal: true

# Smoke: activerecord-health
# Tests Configuration, ModelConfiguration, configure block, per-model overrides,
# and threshold/vcpu arithmetic — all self-contained (no DB connection required).
#
# Stubs Rails::Railtie so --full force-loading of railtie.rb does not fail.

# Minimal Rails stub: railtie.rb does `class Railtie < Rails::Railtie`
module Rails
  class Railtie
    def self.config
      @config ||= Struct.new(:after_initialize).new(->(_block) {})
    end
    def self.inherited(_subclass); end
  end
end

require "activerecord-health"

# 1. Global configuration via configure block
ActiveRecord::Health.configure do |c|
  c.vcpu_count = 8
  c.threshold  = 0.75
  c.cache_ttl  = 30
end

cfg = ActiveRecord::Health.configuration
puts cfg.vcpu_count           # => 8
puts cfg.threshold            # => 0.75
puts cfg.cache_ttl            # => 30
puts cfg.max_healthy_sessions # => 6   (floor(8 * 0.75))

# 2. ConfigurationError raised when vcpu_count is nil
begin
  bad = ActiveRecord::Health::Configuration.new
  bad.cache = Object.new  # set cache so only vcpu_count validation fires
  bad.validate!
  puts "no error"          # should not reach here
rescue ActiveRecord::Health::ConfigurationError => e
  puts e.message           # => "vcpu_count must be configured"
end

# 3. ModelConfiguration inherits from parent, can override threshold
parent_cfg = ActiveRecord::Health::Configuration.new
parent_cfg.vcpu_count = 16
parent_cfg.threshold  = 0.5
parent_cfg.cache_ttl  = 60

model_cfg = ActiveRecord::Health::ModelConfiguration.new(parent_cfg)
puts model_cfg.vcpu_count.inspect   # => nil (not set yet)
puts model_cfg.threshold            # => 0.5  (inherited)
puts model_cfg.cache_ttl            # => 60   (inherited)

model_cfg.vcpu_count = 4
model_cfg.threshold  = 0.25
puts model_cfg.vcpu_count           # => 4
puts model_cfg.threshold            # => 0.25
puts model_cfg.max_healthy_sessions # => 1  (floor(4 * 0.25))

# 4. reset_configuration! clears state
ActiveRecord::Health.reset_configuration!
fresh = ActiveRecord::Health.configuration
puts fresh.threshold            # => 0.75 (default)
puts fresh.cache_ttl            # => 60   (default)
puts fresh.vcpu_count.inspect   # => nil

# 5. for_model registration and lookup
ActiveRecord::Health.configure do |c|
  c.vcpu_count = 10
  c.threshold  = 0.8
end
cfg2 = ActiveRecord::Health.configuration

FakeModel = Class.new

cfg2.for_model(FakeModel) do |mc|
  mc.vcpu_count = 2
  mc.threshold  = 0.5
end

mc = cfg2.for_model(FakeModel)
puts mc.vcpu_count            # => 2
puts mc.threshold             # => 0.5
puts mc.max_healthy_sessions  # => 1  (floor(2 * 0.5))

# Unknown model falls back to global config
UnknownModel = Class.new
fb = cfg2.for_model(UnknownModel)
puts fb.vcpu_count  # => 10
puts fb.threshold   # => 0.8

# 6. MySQLAdapter version comparison
adapter = ActiveRecord::Health::Adapters::MySQLAdapter.new("8.0.25")
puts adapter.name               # => mysql
puts adapter.uses_performance_schema?  # => true (>= 8.0.22)

old_adapter = ActiveRecord::Health::Adapters::MySQLAdapter.new("5.7.0")
puts old_adapter.uses_performance_schema?  # => false

mariadb_adapter = ActiveRecord::Health::Adapters::MySQLAdapter.new("10.6.7-MariaDB")
puts mariadb_adapter.uses_performance_schema?  # => false (mariadb)

# 7. PostgreSQLAdapter
pg_adapter = ActiveRecord::Health::Adapters::PostgreSQLAdapter.new
puts pg_adapter.name  # => postgresql
