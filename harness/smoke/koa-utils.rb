# Pre-set env vars required by KOAUtils::LeaderboardClient module constants
ENV['LEADERBOARD_URL'] = 'http://localhost:9999'
ENV['KOA_GAME_ID']     = 'smoke-game-1'

require 'koa-utils'
require 'stringio'

# KOAUtils::Conf — env var helpers
ENV['KOA_SMOKE_KEY'] = 'hello_world'
puts KOAUtils::Conf.env('KOA_SMOKE_KEY')           # => hello_world
puts KOAUtils::Conf.env('MISSING_KEY').inspect      # => nil

begin
  KOAUtils::Conf.env!('MISSING_KEY')
rescue RuntimeError => e
  puts e.message                                     # => Must set MISSING_KEY
end

# KOAUtils::TimeoutResponse — stub object
tr = KOAUtils::TimeoutResponse.new
puts tr.successful?                                  # => false
puts tr.code                                         # => 0
puts tr.body.inspect                                 # => nil
puts KOAUtils::TimeoutResponse.body_permitted?       # => false

# KOAUtils::Kik::PushResponse — wraps a response-like object
stub_ok  = Struct.new(:code).new('200')
stub_bad = Struct.new(:code).new('403')

puts KOAUtils::Kik::PushResponse.new(stub_ok).success?    # => true
puts KOAUtils::Kik::PushResponse.new(stub_ok).bad_token?  # => false
puts KOAUtils::Kik::PushResponse.new(stub_bad).success?   # => false
puts KOAUtils::Kik::PushResponse.new(stub_bad).bad_token? # => true
puts KOAUtils::Kik::PushResponse.new(nil).success?        # => false

# KOAUtils::Request internal helpers — hash_to_query
result = KOAUtils::Request.send(:hash_to_query, {foo: 'bar', q: 'hello world'})
puts result                                          # => foo=bar&q=hello+world

# build_url with GET params
url = KOAUtils::Request.send(:build_url, {type: :get, url: 'http://example.com/api', data: {page: '1'}})
puts url                                             # => http://example.com/api?page=1

# build_body for POST
body = KOAUtils::Request.send(:build_body, {type: :post, data: {name: 'Alice'}})
puts body                                            # => {"name":"Alice"}

# KOAUtils::Logger — logging utilities
buf = StringIO.new
KOAUtils::Logger.out = buf
KOAUtils::Logger.count('hits', 5)
buf.rewind
puts buf.read.strip                                  # => count#hits=5
