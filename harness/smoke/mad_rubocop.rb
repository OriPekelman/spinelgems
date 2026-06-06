require 'mad_rubocop'
require 'yaml'

# mad_rubocop is a RuboCop config-only gem.
# Its public surface: the MadRubocop module, VERSION, and two YAML config files
# (disabled_cops.yml and modified_cops.yml) that RuboCop inherits via inherit_gem.
# Smoke: parse both YAML config files and verify structure / known entries.

puts MadRubocop::VERSION

# Resolve the gem lib dir via the loaded version.rb path
version_file = $LOADED_FEATURES.grep(/mad_rubocop\/version/).first
gem_lib = File.dirname(File.dirname(version_file))

disabled_path = File.join(gem_lib, 'disabled_cops.yml')
modified_path = File.join(gem_lib, 'modified_cops.yml')

disabled = YAML.safe_load(File.read(disabled_path))
modified = YAML.safe_load(File.read(modified_path))

# Total top-level key counts
puts disabled.keys.count
puts modified.keys.count

# AllCops section must exist in disabled
puts disabled.key?('AllCops')

# Layout/LineLength is disabled
puts disabled.key?('Layout/LineLength')
puts disabled['Layout/LineLength']['Enabled']

# Style/HashSyntax is modified with a non-default style
puts modified.key?('Style/HashSyntax')
puts modified['Style/HashSyntax']['EnforcedStyle']

# Count cops disabled in the Style namespace
style_disabled = disabled.count { |k, v| k.start_with?('Style/') && v.is_a?(Hash) && v['Enabled'] == false }
puts style_disabled
