# Smoke: confidence-check
# Exercises ConfidenceCheck::CheckMethod directly with a custom exception klass
# (avoids the Minitest/RSpec variants which require external gems).

class MyAssertionError < StandardError; end

class MyChecker
  include ConfidenceCheck::CheckMethod

  def exception_klasses
    [MyAssertionError]
  end
end

checker = MyChecker.new

# VERSION constant
puts ConfidenceCheck::VERSION

# passing block returns block value
result = checker.confidence_check { 42 }
puts result

# watched exception gets wrapped in ConfidenceCheckedFailed
begin
  checker.confidence_check { raise MyAssertionError, "assertion failed" }
rescue ConfidenceCheck::ConfidenceCheckedFailed => e
  puts e.message
end

# unwatched exception passes through unwrapped
begin
  checker.confidence_check { raise RuntimeError, "runtime problem" }
rescue ConfidenceCheck::ConfidenceCheckedFailed
  puts "WRONG: should not wrap RuntimeError"
rescue RuntimeError => e
  puts "RuntimeError: #{e.message}"
end

# no block raises a descriptive error
begin
  checker.confidence_check
rescue => e
  puts e.message
end
