require 'kapnismology'

# Exercise Result / Success / NullResult construction and attribute access
passed_result = Kapnismology::Result.new(true, { db: 'ok' }, 'Database reachable')
puts passed_result.passed?
puts passed_result.message
puts passed_result.data.inspect
puts passed_result.to_hash[:passed]

failed_result = Kapnismology::Result.new(false, { reason: 'timeout' }, 'DB unreachable')
puts failed_result.passed?
puts failed_result.message

success = Kapnismology::Success.new({ version: '1.0' }, 'Always good')
puts success.passed?
puts success.data.inspect

null_result = Kapnismology::NullResult.new({ skip: true })
puts null_result.passed?
puts null_result.to_hash.inspect

# Exercise SmokeTest subclass — defines a concrete test with a passing result
class AlwaysPassTest < Kapnismology::SmokeTest
  def result
    Result.new(true, { computed: 1 + 1 }, 'arithmetic works')
  end
end

class AlwaysFailTest < Kapnismology::SmokeTest
  def result
    Result.new(false, { x: 42 }, 'intentional failure')
  end
end

# Run tests via __result__ (the internal harness entry point)
r1 = AlwaysPassTest.new.__result__
puts r1.passed?
puts r1.message
puts r1.data.inspect

r2 = AlwaysFailTest.new.__result__
puts r2.passed?
puts r2.message

# Exercise SmokeTestCollection + EvaluationCollection
collection = Kapnismology::SmokeTestCollection.evaluations([Kapnismology::SmokeTest::RUNTIME_TAG])
# passed? is false because AlwaysFailTest is in the collection
puts collection.passed?
# Count evaluations via Enumerable (skips NotApplicableResult entries)
count = collection.count
puts count >= 2
# total_duration is a non-negative integer
puts collection.total_duration >= 0
