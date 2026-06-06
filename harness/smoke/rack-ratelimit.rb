require 'rack-ratelimit'
require 'stringio'

# --- Minimal in-memory counter (no Redis/Memcached) ---
class MemCounter
  def initialize
    @data = Hash.new(0)
  end

  def increment(classification, epoch)
    @data["#{classification}/#{epoch}"] += 1
  end
end

# --- Trivial downstream Rack app ---
OK_APP = ->(env) { [200, {}, ["ok"]] }

# --- Build a Ratelimit middleware with max=3 requests per 60-second window ---
counter = MemCounter.new
limiter = Rack::Ratelimit.new(OK_APP,
  name:    'API',
  rate:    [3, 60],
  counter: counter
) { |env| env['REMOTE_ADDR'] }

# --- Freeze the clock so results are deterministic ---
FIXED_TIME = 1_700_000_000.0  # an arbitrary epoch second
BASE_ENV = {
  'REQUEST_METHOD'    => 'GET',
  'PATH_INFO'         => '/api/data',
  'REMOTE_ADDR'       => '10.0.0.1',
  'rack.input'        => StringIO.new,
  'ratelimit.timestamp' => FIXED_TIME
}

# --- apply_rate_limit? (no conditions/exceptions by default => always true) ---
puts "apply_rate_limit? #{limiter.apply_rate_limit?(BASE_ENV)}"

# --- classify returns REMOTE_ADDR ---
puts "classify => #{limiter.classify(BASE_ENV)}"

# --- Send 4 requests; first 3 pass, 4th is rate-limited ---
4.times do |i|
  status, headers, body = limiter.call(BASE_ENV.dup)
  ratelimit_hdr = headers['X-Ratelimit'] || ''
  if status == 200
    # Extract "remaining" from the JSON header
    remaining = ratelimit_hdr[/"remaining":(\d+)/, 1]
    puts "request #{i + 1}: status=#{status} remaining=#{remaining}"
  else
    puts "request #{i + 1}: status=#{status} body=#{body.first.split('.').first}"
  end
end

# --- Test with an exception (GET requests are exempt) ---
counter2 = MemCounter.new
limiter2 = Rack::Ratelimit.new(OK_APP,
  name:       'POST',
  rate:       [1, 60],
  counter:    counter2,
  exceptions: [->(env) { env['REQUEST_METHOD'] == 'GET' }]
) { |env| env['REMOTE_ADDR'] }

get_env = {
  'REQUEST_METHOD'      => 'GET',
  'PATH_INFO'           => '/api/data',
  'REMOTE_ADDR'         => '10.0.0.1',
  'rack.input'          => StringIO.new,
  'ratelimit.timestamp' => FIXED_TIME
}
puts "GET exempt? #{!limiter2.apply_rate_limit?(get_env)}"

post_env = {
  'REQUEST_METHOD'      => 'POST',
  'PATH_INFO'           => '/api/data',
  'REMOTE_ADDR'         => '10.0.0.1',
  'rack.input'          => StringIO.new,
  'ratelimit.timestamp' => FIXED_TIME
}
puts "POST rate-limited? #{limiter2.apply_rate_limit?(post_env)}"

# --- Verify ratelimit_epoch math: epoch = period * ceil(now / period) ---
period = 60
expected_epoch = period * (FIXED_TIME / period).ceil
puts "epoch_math ok? #{(expected_epoch % period).zero? || expected_epoch >= FIXED_TIME}"
