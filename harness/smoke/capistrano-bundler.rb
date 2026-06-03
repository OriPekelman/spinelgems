# Smoke: capistrano-bundler 2.2.0
#
# capistrano-bundler is a pure Capistrano 3 DSL plugin. Its main require
# file (lib/capistrano-bundler.rb) is intentionally empty — users load it
# via `require "capistrano/bundler"` inside a Capfile. All logic lives in
# .cap task files using the Rake/Capistrano DSL.
#
# We exercise the algorithmic logic that the task bodies perform:
#   - config_args selection based on bundle_version (>= 4 uses new syntax)
#   - install options array construction (binstubs / jobs / flags)
#   - bundle_without join pattern and default values
#   - bundle_version comparisons across the supported range

# 1. config_args selection (bundler.cap line 19):
#    bundle_version < 4 → ["config"]; >= 4 → ["config", "set"]
v2_args = 2 >= 4 ? ["config", "set"] : ["config"]
v4_args = 5 >= 4 ? ["config", "set"] : ["config"]
puts v2_args.join(" ")
puts v4_args.join(" ")

# 2. Install options array construction (bundler.cap lines 67-73)
# Case A: no binstubs, jobs=4, flags='--quiet'
bundle_binstubs         = nil
bundle_binstubs_command = :install
bundle_jobs  = 4
bundle_flags = "--quiet"

options_a = []
options_a << "--binstubs #{bundle_binstubs}" if bundle_binstubs && bundle_binstubs_command == :install
options_a << "--jobs #{bundle_jobs}"         if bundle_jobs
options_a << bundle_flags                    if bundle_flags
puts options_a.inspect

# Case B: binstubs enabled with :install command
bundle_binstubs = "/shared/bin"
options_b = []
options_b << "--binstubs #{bundle_binstubs}" if bundle_binstubs && bundle_binstubs_command == :install
options_b << "--jobs #{bundle_jobs}"         if bundle_jobs
options_b << bundle_flags                    if bundle_flags
puts options_b.inspect

# Case C: binstubs set but command is :binstubs (not :install) -> --binstubs flag skipped
bundle_binstubs_command = :binstubs
options_c = []
options_c << "--binstubs #{bundle_binstubs}" if bundle_binstubs && bundle_binstubs_command == :install
options_c << "--jobs #{bundle_jobs}"         if bundle_jobs
options_c << bundle_flags                    if bundle_flags
puts options_c.inspect

# 3. Default bundle_bins and bundle_without (load:defaults task)
bundle_bins    = ["gem", "rake", "rails"]
bundle_without = ["development", "test"].join(":")
puts bundle_bins.inspect
puts bundle_without

# 4. bundle_version comparisons across the supported range
[1, 2, 3, 4, 5].each do |v|
  puts "v#{v}: #{v >= 4 ? 'new' : 'old'}"
end

# 5. nil-guard pattern used throughout the tasks
[nil, "/path/to/gemfile", nil, "/shared/bundle"].each do |val|
  puts val.nil? ? "skip" : "use: #{val}"
end
