require_relative "lib/lock"

puts Lock.local("test-input")
puts Lock.local("simple")
puts Lock.local("a/b/c")
puts Lock.local("x-y-z")
