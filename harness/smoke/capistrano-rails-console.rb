# Smoke: capistrano-rails-console
#
# This gem is a Capistrano plugin for remote Rails console access.
# lib/capistrano-rails-console.rb is empty; real logic is in the version module
# and the Capistrano DSL tasks file (tasks.cap).
#
# We exercise: the version module, module hierarchy, VERSION string parsing,
# and the sandbox-args detection logic from the rails:console task.
#
# require_relative is relative to gem root (this file is embedded in
# gem_dir/__spinel_verify.rb by the harness at verification time).

require_relative "lib/capistrano/rails/console/version"

# 1. VERSION constant and module hierarchy
puts Capistrano::Rails::Console::VERSION
v = Capistrano::Rails::Console::VERSION
parts = v.split('.')
puts parts.length
puts parts[0].to_i
puts parts[1].to_i
puts parts[2].to_i
puts(v =~ /\A\d+\.\d+\.\d+\z/ ? "semver:ok" : "semver:bad")

# 2. Module type checks
puts Capistrano.class
puts Capistrano::Rails.class
puts Capistrano::Rails::Console.class
puts Capistrano::Rails::Console.is_a?(Module)
puts Capistrano::Rails::Console.respond_to?(:name)
puts Capistrano::Rails::Console.name

# 3. Sandbox args detection (from tasks.cap rails:console task body):
#   args << '--sandbox' if ENV.key?('sandbox') || ENV.key?('s')
# Replicated with local hashes to avoid ENV side-effects.

env1 = {}
args1 = []
args1 << '--sandbox' if env1.key?('sandbox') || env1.key?('s')
puts args1.length

env2 = {'sandbox' => '1'}
args2 = []
args2 << '--sandbox' if env2.key?('sandbox') || env2.key?('s')
puts args2.length
puts args2[0]

env3 = {'s' => '1'}
args3 = []
args3 << '--sandbox' if env3.key?('sandbox') || env3.key?('s')
puts args3.length
puts args3[0]

# Both flags: still exactly one --sandbox appended
env4 = {'sandbox' => '1', 's' => '1'}
args4 = []
args4 << '--sandbox' if env4.key?('sandbox') || env4.key?('s')
puts args4.length
puts args4[0]
