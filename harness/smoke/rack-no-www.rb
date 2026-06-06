require 'rack-no-www'

# Minimal Rack::Request stub so no external rack gem is required.
# rack-no-www calls only Rack::Request.new(env).url in its private method.
module Rack
  class Request
    def initialize(env)
      @env = env
    end

    def url
      scheme = @env['rack.url_scheme'] || 'http'
      host   = @env['HTTP_HOST'] || @env['SERVER_NAME']
      path   = @env['PATH_INFO'] || '/'
      qs     = @env['QUERY_STRING']
      fullpath = (qs && !qs.empty?) ? "#{path}?#{qs}" : path
      "#{scheme}://#{host}#{fullpath}"
    end
  end
end

# Minimal inner app
inner_app = ->(env) { [200, { 'Content-Type' => 'text/plain' }, ["OK: #{env['HTTP_HOST']}"]] }

middleware = Rack::NoWWW.new(inner_app)

# Build a minimal Rack env
def make_env(host, path = '/', scheme = 'http', qs = '')
  {
    'HTTP_HOST'        => host,
    'PATH_INFO'        => path,
    'QUERY_STRING'     => qs,
    'rack.url_scheme'  => scheme,
    'REQUEST_METHOD'   => 'GET',
    'SERVER_NAME'      => host.sub(/:\d+$/, ''),
    'SERVER_PORT'      => scheme == 'https' ? '443' : '80',
  }
end

# 1. www. host → 301 redirect strips www
env1 = make_env('www.example.com', '/about')
status1, headers1, body1 = middleware.call(env1)
puts "www redirect status: #{status1}"
puts "www redirect location: #{headers1['Location']}"
puts "www redirect body: #{body1.join}"

# 2. Non-www host → passes through to inner app
env2 = make_env('example.com', '/about')
status2, _h2, body2 = middleware.call(env2)
puts "plain pass-through status: #{status2}"
puts "plain pass-through body: #{body2.join}"

# 3. https + www + query string
env3 = make_env('www.example.com', '/search', 'https', 'q=foo')
status3, headers3, _b3 = middleware.call(env3)
puts "https www redirect status: #{status3}"
puts "https www redirect location: #{headers3['Location']}"

# 4. Regex constant — case-insensitive match
puts "WWW regex matches www.foo: #{!!(Rack::NoWWW::STARTS_WITH_WWW =~ 'www.foo')}"
puts "WWW regex matches WWW.foo: #{!!(Rack::NoWWW::STARTS_WITH_WWW =~ 'WWW.foo')}"
puts "WWW regex skips example.com: #{!!(Rack::NoWWW::STARTS_WITH_WWW =~ 'example.com')}"

# 5. VERSION constant
puts "version: #{Rack::NoWWW::VERSION}"
