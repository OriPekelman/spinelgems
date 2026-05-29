puts Testrbl::OPTION_WITH_ARGUMENT.length
puts Testrbl::OPTION_WITH_ARGUMENT.first
puts Testrbl::OPTION_WITH_ARGUMENT.last
puts Testrbl::OPTION_WITH_ARGUMENT.include?("-n")
puts Testrbl::OPTION_WITH_ARGUMENT.include?("--name")
puts Testrbl::PATTERNS.length
puts 'bar \#{baz} qux' =~ Testrbl::INTERPOLATION ? "matched" : "no match"
puts 'no interp here' =~ Testrbl::INTERPOLATION ? "matched" : "no match"
