# frozen_string_literal: true
# Smoke test for danger-xcode_summary 1.5.0
# Stubs Danger::Plugin (from 'danger' gem) before loading the plugin.
# Uses xcresult gem from the load path (added by the harness).
# Exercises: Struct definitions (Location/Result/Warning), sanitized_test_case_name,
# escape_reason, relative_path, project_root default, and attribute defaults.

module Danger
  class Plugin
    def self.all_plugins; []; end
    def self.essential_plugin_classes; []; end
  end
  module Dangerfile
    def self.essential_plugin_classes; []; end
  end
end

require 'danger_xcode_summary'
require 'danger_plugin'

# 1. VERSION constant
puts XcodeSummary::VERSION

# 2. Struct definitions — Location, Result, Warning
loc = Danger::DangerXcodeSummary::Location.new('AppDelegate.swift', '/src/AppDelegate.swift', 17)
puts loc.file_name
puts loc.file_path
puts loc.line

result = Danger::DangerXcodeSummary::Result.new("Use of undeclared type 'Foo'", loc)
puts result.message
puts result.location.file_name

warning = Danger::DangerXcodeSummary::Warning.new('Deprecated: use newAPI()', false, loc)
puts warning.message
puts warning.sticky

# 3. Default attribute values on a fresh instance
plugin = Danger::DangerXcodeSummary.new
puts plugin.sticky_summary.inspect
puts plugin.test_summary.inspect
puts plugin.inline_mode.inspect
puts plugin.ignores_warnings.inspect
puts plugin.strict.inspect
puts plugin.collapse_parallelized_tests.inspect
puts plugin.ignore_retried_tests.inspect

# 4. project_root default (ends with '/')
root = plugin.project_root
puts root.end_with?('/')

# 5. ignored_files default (compact empty array)
puts plugin.ignored_files.inspect

# 6. sanitized_test_case_name (private method)
puts plugin.send(:sanitized_test_case_name, 'MyApp.[UITests testLoginButton]')
puts plugin.send(:sanitized_test_case_name, 'SuiteTests testFoo')
puts plugin.send(:sanitized_test_case_name, 'A.B-C.[D E]')

# 7. escape_reason (private method)
puts plugin.send(:escape_reason, 'Value < 0 or > max')
puts plugin.send(:escape_reason, 'No special chars here')
puts plugin.send(:escape_reason, 'Mix: a<b>c')

# 8. relative_path strips project_root prefix (private method)
plugin.instance_variable_set(:@project_root, '/src/')
puts plugin.send(:relative_path, '/src/AppDelegate.swift')
puts plugin.send(:relative_path, '/src/Models/User.swift')
