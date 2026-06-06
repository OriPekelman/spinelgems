# frozen_string_literal: true

require "rack-ecg"

# 1. Check::Result#as_json
ok_result = Rack::ECG::Check::Result.new(:http, Rack::ECG::Check::Status::OK, "online")
puts ok_result.as_json.inspect
# => {:http=>{:status=>"ok", :value=>"online"}}

# 2. Check::Static with explicit success
static_ok = Rack::ECG::Check::Static.new(name: :mycheck, value: "all good", success: true)
puts static_ok.result.status
# => ok

static_err = Rack::ECG::Check::Static.new(name: :failing, value: "boom", success: false)
puts static_err.result.status
# => error

# 3. CheckRegistry lookup
klass = Rack::ECG::CheckRegistry.lookup(:http)
puts klass.name
# => Rack::ECG::Check::Http

# 4. CheckFactory builds checks and Http check returns "online"
factory = Rack::ECG::CheckFactory.new([:http])
checks = factory.build_all
result = checks.first.result
puts result.as_json.inspect
# => {:http=>{:status=>"ok", :value=>"online"}}

# 5. Full Rack::ECG middleware call
ecg = Rack::ECG.new(nil, checks: [
  :http,
  [:static, { name: :deployment, value: "v1", success: true }],
])

env = { "PATH_INFO" => Rack::ECG::DEFAULT_MOUNT_AT }
status, headers, body = ecg.call(env)
puts status
# => 200
puts headers["content-type"]
# => application/json
parsed = JSON.parse(body.join)
puts parsed["http"]["status"]
# => ok
puts parsed["deployment"]["status"]
# => ok

# 6. ECG returns 404 for unmatched path with no downstream app
env2 = { "PATH_INFO" => "/other" }
s2, _, _ = ecg.call(env2)
puts s2
# => 404

# 7. Result#to_json
err_result = Rack::ECG::Check::Result.new(:db, Rack::ECG::Check::Status::ERROR, "timeout")
puts err_result.to_json
# => {"db":{"status":"error","value":"timeout"}}
