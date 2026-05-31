# TopTests smoke — exercises ClassMethods without requiring Minitest

# Build a synthetic class that extends ClassMethods directly
klass = Class.new
klass.extend(TopTests::ClassMethods)

# Inject some fake test durations
klass.tests_durations << ["MyTest#test_a", 1.5]
klass.tests_durations << ["MyTest#test_b", 0.3]
klass.tests_durations << ["MyTest#test_c", 2.7]

# top_tests sorts descending by duration
top = klass.top_tests
top.each { |t| puts "#{t[0]}: #{format("%.1f", t[1])}" }

# format_tests produces aligned output
puts klass.format_tests([["MyTest#test_slow", 3.14159]])

# slow_tests with no max_duration set returns empty array
puts klass.slow_tests.length
