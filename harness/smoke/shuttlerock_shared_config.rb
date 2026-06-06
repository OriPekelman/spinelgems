# frozen_string_literal: true
# Smoke: shuttlerock_shared_config
# This gem provides a module and Rake tasks that copy shared config templates
# (rubocop, eslint, etc.) into a consuming project.
# The tasks require 'rake' (an external gem, ignored by Spinel) so we load
# only the version subfile and exercise the pure-Ruby logic directly.

require 'shuttlerock_shared_config/version'

# 1. Module identity
puts ShuttlerockSharedConfig.name
puts ShuttlerockSharedConfig::VERSION

# 2. The VERSION string must match expected semver format
parts = ShuttlerockSharedConfig::VERSION.split('.')
puts "version-parts:#{parts.length}"
puts parts.all? { |p| p.chars.all? { |c| c >= '0' && c <= '9' } } ? 'version-numeric:ok' : 'version-numeric:fail'

# 3. Module is a Module (not a Class)
puts ShuttlerockSharedConfig.is_a?(Module) ? 'is-module:ok' : 'is-module:fail'
puts ShuttlerockSharedConfig.is_a?(Class) ? 'is-class:unexpected' : 'is-class:ok'

# 4. String operations from the tasks: warn messages use string interpolation
#    and File.expand_path with multi-segment relative paths (core gem logic)
name = 'shuttlerock_shared_config'
puts name.split('_').map(&:capitalize).join

# 5. Simulate the file-copy path resolution from tasks.rb.
#    tasks.rb uses: File.expand_path('../../lib/templates/<file>', __dir__)
#    This tests that File.expand_path handles multi-level '..' correctly.
base = '/some/gem/lib/tasks'
resolved = File.expand_path('../../lib/templates/codecov.yml', base)
puts resolved
puts resolved.end_with?('lib/templates/codecov.yml') ? 'expand-path:ok' : 'expand-path:fail'

# 6. Verify the path join pattern used with Dir.pwd in tasks
fake_pwd = '/project'
result_dir = fake_pwd + '/.github'
puts result_dir
puts File.join(result_dir, 'some_file') == '/project/.github/some_file' ? 'path-join:ok' : 'path-join:fail'
