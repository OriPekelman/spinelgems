require 'no_proxy_fix'
require 'uri'

# no_proxy_fix monkey-patches URI::Generic#find_proxy.
# We call it with a synthetic env hash to avoid network and real ENV.

uri = URI.parse('http://example.com/path')

# 1. No proxy configured => nil
result1 = uri.find_proxy({})
puts result1.nil? ? "no_proxy=nil" : "no_proxy=#{result1}"

# 2. http_proxy set => returns proxy URI
env2 = { 'http_proxy' => 'http://proxy.local:3128' }
result2 = uri.find_proxy(env2)
puts result2 ? "proxy=#{result2}" : "proxy=nil"

# 3. no_proxy matches host => nil (bypass proxy)
env3 = { 'http_proxy' => 'http://proxy.local:3128', 'no_proxy' => 'example.com' }
result3 = uri.find_proxy(env3)
puts result3.nil? ? "bypassed=true" : "bypassed=false"

# 4. no_proxy does NOT match => proxy returned
env4 = { 'http_proxy' => 'http://proxy.local:3128', 'no_proxy' => 'other.com' }
result4 = uri.find_proxy(env4)
puts result4 ? "not_bypassed=#{result4.host}:#{result4.port}" : "not_bypassed=nil"

# 5. VERSION constant is accessible
puts "version=#{NoProxyFix::VERSION}"
