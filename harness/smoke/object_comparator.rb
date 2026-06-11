cmp = ObjectComparator.new

# equal? with identical simple objects
puts cmp.equal?(1, 1)
puts cmp.equal?("hello", "hello")
puts cmp.equal?(1, 2)
puts cmp.equal?([1,2,3], [1,2,3])
puts cmp.equal?([1,2], [1,3])

# failing messages
puts cmp.failing_message_for_should(42, 99)
puts cmp.failing_message_for_should_not("a", "b")

# InspectionString strips hex addresses
str = ObjectComparator::InspectionString.new("hello")
puts str.to_s
