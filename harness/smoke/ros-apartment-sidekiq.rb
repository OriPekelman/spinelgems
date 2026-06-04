require 'apartment/sidekiq/version'
require 'apartment/sidekiq/middleware/client'
require 'apartment/sidekiq/middleware/server'

# Stub Apartment::Tenant (normally depends on ActiveRecord + DB)
module Apartment
  module Tenant
    @current = 'public'

    def self.current
      @current
    end

    def self.switch(tenant)
      old = @current
      @current = tenant
      yield
    ensure
      @current = old
    end
  end
end

puts Apartment::Sidekiq::VERSION

# Exercise Client middleware: stamps apartment into item when absent
client = Apartment::Sidekiq::Middleware::Client.new
item1 = {}
client.call('MyWorker', item1, 'default') { }
puts item1['apartment']   # => "public" (current tenant)

# Client middleware: does NOT overwrite if apartment already set
item2 = { 'apartment' => 'tenant_acme' }
client.call('MyWorker', item2, 'default') { }
puts item2['apartment']   # => "tenant_acme" (unchanged)

# Exercise Server middleware: switches tenant for the block duration
server = Apartment::Sidekiq::Middleware::Server.new
item3 = { 'apartment' => 'tenant_beta' }
captured_inside = nil
server.call('MyWorker', item3, 'default') do
  captured_inside = Apartment::Tenant.current
end
puts captured_inside             # => "tenant_beta" (switched during job)
puts Apartment::Tenant.current   # => "public" (restored after)

# Server with nil apartment: switch to nil, still restores
item4 = { 'apartment' => nil }
server.call('MyWorker', item4, 'default') { }
puts Apartment::Tenant.current   # => "public" (restored)

# Client middleware with explicit redis_pool arg (optional 4th param)
item5 = {}
pool = Object.new
client.call('OtherWorker', item5, 'low', pool) { }
puts item5['apartment']   # => "public"
