# Smoke test for szymanskis_mutex gem
# Single-threaded calls -- no sleep loops are triggered in single-process use.

result1 = SzymanskisMutex.mutual_exclusion(:task_a) { 1 + 1 }
puts result1

result2 = SzymanskisMutex.mutual_exclusion(:task_b) { "hello" }
puts result2

result3 = SzymanskisMutex.mutual_exclusion(:task_a) { [1, 2, 3].map { |x| x * 2 } }
puts result3.inspect

result4 = SzymanskisMutex.mutual_exclusion(:task_c) { 42 }
puts result4

puts SzymanskisMutex.class
