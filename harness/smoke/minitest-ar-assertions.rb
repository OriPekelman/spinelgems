require_relative "lib/minitest_activerecord_assertions"

puts MiniTest::ActiveRecordAssertions.class
puts MiniTest::ActiveRecordAssertions.instance_methods(false).sort.inspect
puts MiniTest::ActiveRecordAssertions.is_a?(Module)
