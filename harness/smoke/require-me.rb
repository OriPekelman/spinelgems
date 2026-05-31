Require.base_path = "/base/path"
Require.tracing = :on
Require.verbose = :on
puts Require.base_path
puts Require.tracing
puts Require.verbose
puts Require.send(:tracing?, {})
puts Require.send(:tracing?, {tracing: :on})
puts Require.send(:is_root?, "/base/path/a", {root: "/base/path"})
puts Require.send(:is_root?, "/short", {root: "/longer/path"})
puts Require.send(:is_root?, "x", {root: nil})
