require 'errbase'

# VERSION constant
puts Errbase::VERSION

# report with no reporters defined is a no-op, returns nil
result = Errbase.report(RuntimeError.new("boom"), { context: "test" })
puts result.nil? ? "report-nil" : "report-non-nil"

# report with just an exception, no info hash
result2 = Errbase.report(StandardError.new("oops"))
puts result2.nil? ? "report-nil-2" : "report-non-nil-2"

# report handles empty info hash (info.any? branch in Bugsnag path)
result3 = Errbase.report(ArgumentError.new("bad"), {})
puts result3.nil? ? "report-nil-3" : "report-non-nil-3"

puts "done"
