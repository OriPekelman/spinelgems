require_relative 'lib/makandra_rubocop'

# 1. Module is defined with correct version constant
puts MakandraRubocop::VERSION

# 2. Version parts — real arithmetic on the version string
parts = MakandraRubocop::VERSION.split('.').map(&:to_i)
major, minor, patch = parts
puts "major=#{major} minor=#{minor} patch=#{patch}"
puts "version_integer=#{major * 10_000 + minor * 100 + patch}"

# 3. Module ancestry and constant inspection
ancestors = MakandraRubocop.ancestors
puts "is_module=#{MakandraRubocop.is_a?(Module)}"
puts "ancestors_include_self=#{ancestors.include?(MakandraRubocop)}"
puts "constants_count=#{MakandraRubocop.constants.length}"
puts "has_VERSION=#{MakandraRubocop.constants.include?(:VERSION)}"

# 4. Version satisfies expected constraints (>= 1.0.0 for a mature gem)
puts "major_positive=#{major > 0}"
puts "version_frozen=#{MakandraRubocop::VERSION.frozen?}"

# 5. Config file paths — locate gem root as the dir containing the harness
gem_root = File.dirname(__FILE__)
config_default = File.join(gem_root, 'config', 'default.yml')
config_rails   = File.join(gem_root, 'config', 'ext', 'rails.yml')
config_rspec   = File.join(gem_root, 'config', 'ext', 'rspec.yml')
puts "default_yml_exists=#{File.exist?(config_default)}"
puts "rails_yml_exists=#{File.exist?(config_rails)}"
puts "rspec_yml_exists=#{File.exist?(config_rspec)}"

# 6. Read config/default.yml and count cops defined (lines with 'Enabled:')
default_content = File.read(config_default)
enabled_count   = default_content.scan(/Enabled:/).length
puts "enabled_entries=#{enabled_count}"
puts "has_AllCops=#{default_content.include?('AllCops:')}"
