require 'rack-strip-cookies'

# Minimal fake Rack app that echoes back the env's HTTP_COOKIE and returns a Set-Cookie header
class FakeApp
  def call(env)
    cookie_sent = env["HTTP_COOKIE"] || "(none)"
    headers = { "Content-Type" => "text/plain", "Set-Cookie" => "session=abc; Path=/" }
    body = ["cookie_sent=#{cookie_sent}"]
    [200, headers, body]
  end
end

fake_app = FakeApp.new

# --- Test 1: path match strips cookies ---
middleware = Rack::StripCookies.new(fake_app, paths: ["/api"])
env = { "PATH_INFO" => "/api/v1", "HTTP_COOKIE" => "user=alice" }
status, headers, body = middleware.call(env)
puts "T1 status=#{status}"
puts "T1 body=#{body.first}"
puts "T1 set-cookie=#{headers.key?("Set-Cookie") ? "present" : "absent"}"

# --- Test 2: non-matching path leaves cookies intact ---
env2 = { "PATH_INFO" => "/home", "HTTP_COOKIE" => "user=bob" }
status2, headers2, body2 = middleware.call(env2)
puts "T2 status=#{status2}"
puts "T2 body=#{body2.first}"
puts "T2 set-cookie=#{headers2.key?("Set-Cookie") ? "present" : "absent"}"

# --- Test 3: wildcard pattern ---
middleware3 = Rack::StripCookies.new(fake_app, paths: ["/static/*"])
env3 = { "PATH_INFO" => "/static/images/logo.png", "HTTP_COOKIE" => "track=1" }
status3, headers3, body3 = middleware3.call(env3)
puts "T3 status=#{status3}"
puts "T3 body=#{body3.first}"
puts "T3 set-cookie=#{headers3.key?("Set-Cookie") ? "present" : "absent"}"

# --- Test 4: invert=true strips cookies on NON-matching paths ---
middleware4 = Rack::StripCookies.new(fake_app, paths: ["/api"], invert: true)
env4 = { "PATH_INFO" => "/public", "HTTP_COOKIE" => "track=xyz" }
status4, headers4, body4 = middleware4.call(env4)
puts "T4 status=#{status4}"
puts "T4 body=#{body4.first}"
puts "T4 set-cookie=#{headers4.key?("Set-Cookie") ? "present" : "absent"}"

# --- Test 5: expose_header ---
middleware5 = Rack::StripCookies.new(fake_app, paths: ["/api"], expose_header: true)
env5 = { "PATH_INFO" => "/api/data", "HTTP_COOKIE" => "session=s1" }
status5, headers5, body5 = middleware5.call(env5)
puts "T5 cookies-stripped=#{headers5["cookies-stripped"]}"

# --- Test 6: root path "/" strips everything ---
middleware6 = Rack::StripCookies.new(fake_app, paths: ["/"])
env6 = { "PATH_INFO" => "/anything/here", "HTTP_COOKIE" => "x=1" }
status6, headers6, body6 = middleware6.call(env6)
puts "T6 body=#{body6.first}"
puts "T6 set-cookie=#{headers6.key?("Set-Cookie") ? "present" : "absent"}"

# --- Test 7: compile_patterns produces regexps ---
mw7 = Rack::StripCookies.new(fake_app, paths: ["/api", "/admin/*"])
puts "T7 patterns=#{mw7.patterns.map(&:source).join(", ")}"
