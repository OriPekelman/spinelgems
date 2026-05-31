require_relative "/home/oripekelman/.cache/spinel-compat/gems/silencer-2.0.0/lib/silencer/version"
require_relative "/home/oripekelman/.cache/spinel-compat/gems/silencer-2.0.0/lib/silencer/util"

puts Silencer::VERSION
puts Silencer::Util.wrap(nil).inspect
puts Silencer::Util.wrap("hello").inspect
puts Silencer::Util.wrap(["a", "b"]).inspect
args = ["x", "y", {foo: 1}]
opts = Silencer::Util.extract_options!(args)
puts opts.inspect
puts args.inspect
