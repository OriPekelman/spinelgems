puts LintRoller::VERSION

about = LintRoller::About.new(
  name: "test-plugin",
  version: "2.0.0",
  homepage: "https://example.com",
  description: "A test plugin"
)
puts about.name
puts about.version
puts about.homepage
puts about.description

ctx = LintRoller::Context.new(
  runner: :standard,
  runner_version: "1.0.0",
  engine: :rubocop,
  engine_version: "1.2.3",
  rule_format: :rubocop,
  target_ruby_version: nil
)
puts ctx.runner
puts ctx.engine

rules = LintRoller::Rules.new(type: :path, config_format: :rubocop, value: "/tmp/rubocop.yml")
puts rules.type
puts rules.config_format

plugin = LintRoller::Plugin.new({foo: "bar"})
puts plugin.supported?(ctx)
