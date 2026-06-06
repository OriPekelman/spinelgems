# Smoke test for danger-eslint 0.1.6
# danger-eslint is a Danger plugin that lints JS files via eslint.
# It requires 'mkmf' (for find_executable) and 'danger-plugin-api'.
# We stub mkmf (ruby dev headers absent) and Danger::Plugin to exercise
# the pure-Ruby logic: attribute accessors with lazy defaults and VERSION.

# Stub mkmf so the require doesn't blow up without ruby-dev headers.
# We find the full on-disk path (needed for $LOADED_FEATURES dedup) and
# also define find_executable so callers don't blow up at runtime.
_mkmf_path = $LOAD_PATH.map { |d| File.join(d, 'mkmf.rb') }.find { |f| File.exist?(f) }
$LOADED_FEATURES << _mkmf_path if _mkmf_path
def find_executable(name, path = nil)
  search = path || ENV['PATH'] || ''
  search.split(File::PATH_SEPARATOR).each do |dir|
    f = File.join(dir, name.to_s)
    return f if File.executable?(f) && !File.directory?(f)
  end
  nil
end

# Stub Danger::Plugin base class (lives in the 'danger' gem, not available here)
module Danger
  class Plugin
    def initialize; end
  end
end

# Load the plugin (danger_plugin.rb -> eslint/plugin.rb)
require 'danger_plugin'
# Load gem_version (danger_eslint.rb -> eslint/gem_version.rb)
require 'danger_eslint'

# 1. VERSION constant
puts Eslint::VERSION

# 2. Default bin_path (lazy-initialized)
e1 = Danger::DangerEslint.new
puts e1.bin_path

# 3. Override bin_path
e1.bin_path = '/opt/node/bin/eslint'
puts e1.bin_path

# 4. Default target_extensions
e2 = Danger::DangerEslint.new
puts e2.target_extensions.inspect

# 5. Override target_extensions
e2.target_extensions = ['.jsx', '.tsx', '.mjs']
puts e2.target_extensions.inspect

# 6. config_file default (nil)
e3 = Danger::DangerEslint.new
puts e3.config_file.inspect

# 7. Set and read config_file
e3.config_file = '.eslintrc.json'
puts e3.config_file

# 8. ignore_file default (nil)
puts e3.ignore_file.inspect

# 9. Set and read ignore_file
e3.ignore_file = '.eslintignore'
puts e3.ignore_file

# 10. filtering default (nil / falsy)
e4 = Danger::DangerEslint.new
puts e4.filtering.inspect

# 11. Set filtering true
e4.filtering = true
puts e4.filtering

# 12. DangerEslint is a subclass of Danger::Plugin
puts Danger::DangerEslint.ancestors.include?(Danger::Plugin)
