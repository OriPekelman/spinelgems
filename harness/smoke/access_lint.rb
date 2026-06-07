require 'access_lint'
require 'json'

# 1. Module structure and error class hierarchy
puts AccessLint::VERSION

puts AccessLint::Error.ancestors.include?(StandardError)
puts AccessLint::AuditError.ancestors.include?(AccessLint::Error)
puts AccessLint::ParserError.ancestors.include?(AccessLint::Error)

# 2. Runner constant: path construction (pure Ruby, no phantomjs exec)
runner = AccessLint::Runner.new("http://example.com")
path = AccessLint::Runner::RUNNER_PATH
puts path.end_with?("vendor/access-lint/bin/auditor.js")
puts File.basename(path)

# 3. Audit parse_output logic (inject JSON directly via monkey-patch to skip phantomjs)
module AccessLint
  class Runner
    def run
      @output = JSON.generate([
        { "status" => "PASS", "description" => "Images have alt text", "elements" => ["<img alt='ok'>"] },
        { "status" => "FAIL", "description" => "No color contrast", "elements" => ["<p>"] },
        { "status" => "PASS", "description" => "Form labels present", "elements" => [] }
      ])
    end
  end
end

audit = AccessLint::Audit.new("http://example.com")
audit.run
results = audit.instance_variable_get(:@results)

puts results.keys.sort.inspect
puts results["PASS"].length
puts results["FAIL"].length
puts results["PASS"].first["description"]
puts results["PASS"].first.key?("elements")  # elements deleted by map

# 4. Exception raising - ParserError on invalid JSON
begin
  bad_audit = AccessLint::Audit.new("x")
  module AccessLint
    class Runner
      def run; @output = "not-json-{{{"; end
    end
  end
  bad_audit.run
rescue AccessLint::ParserError => e
  puts "ParserError: #{e.message.empty? ? 'raised' : 'raised'}"
rescue => e
  puts "Error: #{e.class}"
end
