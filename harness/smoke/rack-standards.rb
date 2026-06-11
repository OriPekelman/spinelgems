# Rack::Standards is a Rack middleware that sets X-UA-Compatible header
# We exercise it via call() with a minimal mock app

mock_app = proc { |env| [200, {}, ["body"]] }

s_default = Rack::Standards.new(mock_app, true)
status, headers, body = s_default.call({})
puts status
puts headers["X-UA-Compatible"]

s_builtin = Rack::Standards.new(mock_app, :builtin)
_, h2, _ = s_builtin.call({})
puts h2["X-UA-Compatible"]

s_off = Rack::Standards.new(mock_app, false)
_, h3, _ = s_off.call({})
puts h3["X-UA-Compatible"].nil?
