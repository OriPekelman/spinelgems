require_relative "/home/oripekelman/.cache/spinel-compat/gems/silencer-2.0.0/lib/silencer/version"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/silencer-2.0.0/lib/silencer/util"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/silencer-2.0.0/lib/silencer/methods"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/silencer-2.0.0/lib/silencer/hush"

# VERSION
puts Silencer::VERSION

# Silencer::Util.wrap — nil, scalar, array
puts Silencer::Util.wrap(nil).inspect
puts Silencer::Util.wrap("hello").inspect
puts Silencer::Util.wrap(["a", "b"]).inspect

# Silencer::Util.extract_options! — hash present and absent
args = ["x", "y", { foo: 1 }]
opts = Silencer::Util.extract_options!(args)
puts opts.inspect
puts args.inspect

args2 = [1, 2]
opts2 = Silencer::Util.extract_options!(args2)
puts opts2.inspect
puts args2.inspect

# Silencer::Methods.define_routes — builds per-HTTP-method silence lists
class TestMethods
  include Silencer::Methods
  include Silencer::Util
end
tm = TestMethods.new
routes = tm.define_routes(["/healthz", /^\/assets/], { get: "/ping" })
puts routes["GET"].include?("/ping").to_s
puts routes["GET"].include?("/healthz").to_s
puts routes["POST"].include?("/healthz").to_s
puts routes["POST"].include?("/ping").to_s

# Silencer::Hush.silence_request? — path/header matching logic
class TestHush
  include Silencer::Hush
  def initialize(routes, silence)
    @routes  = routes
    @silence = silence
  end
  public :silence_request?
end
th = TestHush.new({ "GET" => ["/healthz", /^\/assets/] }, [])

# exact path silenced
env1 = { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/healthz",
         "HTTP_X_SILENCE_LOGGER" => nil }
puts th.silence_request?(env1).to_s

# regex path silenced
env2 = { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/assets/app.js",
         "HTTP_X_SILENCE_LOGGER" => nil }
puts th.silence_request?(env2).to_s

# non-silenced path
env3 = { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/api/users",
         "HTTP_X_SILENCE_LOGGER" => nil }
puts th.silence_request?(env3).to_s

# header-based silencing (enable_header true/false)
env4 = { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/api/users",
         "HTTP_X_SILENCE_LOGGER" => "1" }
puts th.silence_request?(env4, enable_header: true).to_s
puts th.silence_request?(env4, enable_header: false).to_s
