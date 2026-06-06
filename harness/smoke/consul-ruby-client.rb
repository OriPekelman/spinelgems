# Smoke: consul-ruby-client
# Stubs rest-client and representable (external runtime deps) so the gem's
# pure logic layers are reachable without network access.

# Stub representable — models include these modules for JSON serialisation.
# We only need the DSL declarations (property/collection) to not raise; we
# don't call from_json/to_json in the smoke.
module Representable
  module JSON
    def self.included(base)
      base.extend(ClassMethods) if base.is_a?(Module)
    end
    module ClassMethods
      def property(*); end
      def collection(*); end
    end
  end
  module Hash
    def self.included(base)
      base.extend(ClassMethods) if base.is_a?(Module)
    end
    module ClassMethods
      def property(*); end
      def collection(*); end
    end
    module AllowSymbols
      def self.included(base); end
    end
  end
end

# Intercept plain `require` for external gems we've stubbed above
module Kernel
  alias_method :__cr_require, :require
  def require(name)
    return true if name.to_s.start_with?('representable')
    return true if name.to_s == 'rest-client'
    __cr_require(name)
  end
end

# Stub RestClient so consul/client/base.rb loads without the gem installed
module RestClient
  @proxy = nil
  def self.proxy; @proxy; end
  def self.proxy=(v); @proxy = v; end
  def self.get(url, opts = {}); raise IOError, "no consul agent (stub)"; end
  def self.put(url, body, opts = {}, &blk); raise IOError, "no consul agent (stub)"; end
end

require_relative 'lib/consul/client'

# 1. Version constant
puts Consul::Client::VERSION

# 2. Consul::Utils.valid_json? — pure JSON parsing; the only externally-testable
#    logic that needs no network (all client methods require a running Consul agent)
puts Consul::Utils.valid_json?('{"key":"value","n":42}')   # true
puts Consul::Utils.valid_json?('[1,2,3]')                  # true
puts Consul::Utils.valid_json?('null')                     # true
puts Consul::Utils.valid_json?('')                         # false
puts Consul::Utils.valid_json?('not json')                 # false
puts Consul::Utils.valid_json?('{bad:}')                   # false
puts Consul::Utils.valid_json?('{"nested":{"a":1}}')       # true

# 3. Base constructor validation (real TypeError path)
begin
  Consul::Client::Base.new('not a hash')
rescue TypeError => e
  puts "TypeError: #{e.message}"
end

# 4. Base URL-construction logic — pure string math, zero network
base = Consul::Client::Base.new(api_host: '10.0.0.1', api_port: '9500', version: 'v2', data_center: 'dc2')
puts base.send(:data_center)
puts base.send(:host)
puts base.send(:port)
puts base.send(:version)
puts base.send(:base_versioned_url)

# Default options path
base2 = Consul::Client::Base.new
puts base2.send(:data_center)
puts base2.send(:host)
puts base2.send(:port)
puts base2.send(:version)
puts base2.send(:base_versioned_url)

# 5. Agent::HealthCheck factory — creates plain OpenStruct objects, no network
hc_ttl = Consul::Client::Agent::HealthCheck.ttl('my_check', '15s')
puts hc_ttl.name
puts hc_ttl.ttl

hc_http = Consul::Client::Agent::HealthCheck.http('http_check', 'http://example.com/health', '10s')
puts hc_http.name
puts hc_http.http
puts hc_http.interval

hc_script = Consul::Client::Agent::HealthCheck.script('script_check', '/usr/bin/check.sh', '30s')
puts hc_script.name
puts hc_script.script
puts hc_script.interval

# 6. Agent::Service factory — pure object construction
svc = Consul::Client::Agent::Service.for_name('my_service')
puts svc.name

svc_with_check = Consul::Client::Agent::Service.for_name('db_service', hc_ttl)
puts svc_with_check.name
puts svc_with_check.check.name
