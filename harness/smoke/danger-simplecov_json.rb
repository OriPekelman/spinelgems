# smoke: danger-simplecov_json
# Tests the core formatting/parsing logic from the plugin,
# stubbing out the Danger::Plugin base class and terminal-table
# (both are external deps not available in Spinel's loadpath).

require 'danger_simplecov_json'

# Verify the VERSION constant
puts SimpleCovJson::VERSION

# Stub Danger::Plugin so we can instantiate DangerSimpleCovJson
module Danger
  class Plugin
    def initialize; end
    def message(msg, sticky: true)
      puts "MESSAGE: #{msg}"
    end
    def fail(msg)
      puts "FAIL: #{msg}"
    end
    def markdown(msg)
      puts "MARKDOWN:\n#{msg}"
    end
  end
end

# Stub terminal-table BEFORE requiring plugin (the method does require 'terminal-table' inline)
module Terminal
  class Table
    def initialize(headings: [], rows: [], style: {})
      @headings = headings
      @rows = rows
    end
    def to_s
      header = "| #{@headings.join(' | ')} |"
      separator = "|#{'-' * 30}|"
      rows_str = @rows.map { |r| "| #{r.join(' | ')} |" }.join("\n")
      "#{separator}\n#{header}\n#{separator}\n#{rows_str}\n#{separator}"
    end
  end
end
# Mark terminal-table as already loaded so inline require is a no-op
$LOADED_FEATURES << 'terminal-table' unless $LOADED_FEATURES.include?('terminal-table')

require 'simplecov_json/plugin'

plugin = Danger::DangerSimpleCovJson.new

# Test the format logic used in report() — parse coverage metrics and format
percentage = 87.654321
lines = 1512
total_lines = 1525
formatted_percentage = format('%.02f', percentage)
puts "Formatted: #{formatted_percentage}"
puts "Coverage line: Code coverage is now at #{formatted_percentage}% (#{lines}/#{total_lines} lines)"

# Test individual_coverage_message
covered_files = [
  { filename: '/project/app/models/user.rb', covered_percent: 95.0 },
  { filename: '/project/app/models/post.rb', covered_percent: 72.5 },
  { filename: '/project/lib/helper.rb',       covered_percent: 100.0 }
]

result = plugin.individual_coverage_message(covered_files)
puts result
