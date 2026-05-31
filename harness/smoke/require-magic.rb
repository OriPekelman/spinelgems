# Smoke: require-magic - simple module accessors (pure, no filesystem/rake dependency)
Require.base_path = '/some/base/path'
puts Require.base_path

Require.tracing = :on
puts Require.tracing

Require.verbose = :off
puts Require.verbose

Require.base_path = nil
puts Require.base_path.inspect

Require.tracing = nil
puts Require.tracing.inspect
