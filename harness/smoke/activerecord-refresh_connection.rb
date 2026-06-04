# Smoke for activerecord-refresh_connection 0.0.5
# Rack middleware that refreshes AR connections between requests.
# ActiveRecord and Rack are not available; we stub the minimum surface
# BEFORE the gem loads so Spinel sees the constants in scope.

# ----- Minimal stubs (must come before the gem's lib is inlined) -----------

module Rack
  class BodyProxy
    def initialize(body, &block)
      @body  = body
      @block = block
    end

    def close
      @block.call
    end
  end
end

module ActiveRecord
  module ConnectionAdapters
  end

  module Base
    @all_count    = 0
    @active_count = 0

    class << self
      attr_reader :all_count, :active_count

      def clear_all_connections!
        @all_count += 1
      end

      def clear_active_connections!
        @active_count += 1
      end

      def reset!
        @all_count    = 0
        @active_count = 0
      end
    end
  end
end

require 'activerecord-refresh_connection'

# ---- Helpers ---------------------------------------------------------------

def rack_env(testing: false)
  env = {}
  env['rack.test'] = true if testing
  env
end

trivial_app = lambda do |env|
  [200, {'Content-Type' => 'text/plain'}, ['OK']]
end

# ---- 1. DEFAULT_OPTIONS constant -------------------------------------------
puts "DEFAULT_OPTIONS: #{ActiveRecord::ConnectionAdapters::RefreshConnectionManagement::DEFAULT_OPTIONS.inspect}"

# ---- 2. Default max_requests=1: first call clears all connections ----------
mid1 = ActiveRecord::ConnectionAdapters::RefreshConnectionManagement.new(trivial_app)
ActiveRecord::Base.reset!
status, _headers, body = mid1.call(rack_env)
body.close
puts "status: #{status}"
puts "all (expect 1): #{ActiveRecord::Base.all_count}"
puts "active (expect 0): #{ActiveRecord::Base.active_count}"

# ---- 3. max_requests=3: counter-based clearing -----------------------------
mid3 = ActiveRecord::ConnectionAdapters::RefreshConnectionManagement.new(trivial_app, max_requests: 3)
ActiveRecord::Base.reset!
3.times { _, _, b = mid3.call(rack_env); b.close }
puts "max3 after 3 — all: #{ActiveRecord::Base.all_count}, active: #{ActiveRecord::Base.active_count}"

# Second cycle after counter reset
ActiveRecord::Base.reset!
3.times { _, _, b = mid3.call(rack_env); b.close }
puts "max3 cycle2 — all: #{ActiveRecord::Base.all_count}, active: #{ActiveRecord::Base.active_count}"

# ---- 4. rack.test suppresses clearing --------------------------------------
mid_t = ActiveRecord::ConnectionAdapters::RefreshConnectionManagement.new(trivial_app)
ActiveRecord::Base.reset!
_, _, body = mid_t.call(rack_env(testing: true))
body.close
puts "rack.test — all: #{ActiveRecord::Base.all_count}, active: #{ActiveRecord::Base.active_count}"

# ---- 5. Exception path clears and re-raises --------------------------------
exploding_app = lambda { |env| raise RuntimeError, "boom" }
mid_ex = ActiveRecord::ConnectionAdapters::RefreshConnectionManagement.new(exploding_app)
ActiveRecord::Base.reset!
begin
  mid_ex.call(rack_env)
rescue RuntimeError => e
  puts "raised: #{e.message}"
end
puts "ex path — all: #{ActiveRecord::Base.all_count}, active: #{ActiveRecord::Base.active_count}"

puts "smoke ok"
