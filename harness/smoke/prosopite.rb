# Test DEFAULT_ALLOW_LIST constant
puts Prosopite::DEFAULT_ALLOW_LIST.length
puts Prosopite::DEFAULT_ALLOW_LIST[1]
puts Prosopite::DEFAULT_ALLOW_LIST[0].class

# Test NPlusOneQueriesError is defined
puts Prosopite::NPlusOneQueriesError.ancestors.include?(StandardError)
puts Prosopite::NPlusOneQueriesError.superclass
