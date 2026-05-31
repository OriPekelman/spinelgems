# stub_env: RSpec helper gem — only the module structure is testable without RSpec
puts StubEnv.is_a?(Module)
puts StubEnv::Helpers.is_a?(Module)
puts StubEnv::Helpers.instance_methods(false).sort.inspect
puts StubEnv::Helpers.private_instance_methods(false).sort.inspect
