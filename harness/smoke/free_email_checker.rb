# Test VERSION constant
puts FreeEmailChecker::VERSION

# Test invalid email (no @ sign)
r1 = FreeEmailChecker.check("notanemail")
puts r1[:free]
puts r1[:domain]
puts r1[:status]

# Test free email domain (gmail.com is in the bundled list, no network needed)
r2 = FreeEmailChecker.check("user@gmail.com")
puts r2[:free]
puts r2[:domain]
puts r2[:status]
