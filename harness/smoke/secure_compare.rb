puts SecureCompare.compare("hello", "hello").inspect
puts SecureCompare.compare("hello", "world").inspect
puts SecureCompare.compare("abc", "abcd").inspect
puts SecureCompare.compare("", "").inspect
puts SecureCompare.compare("x" * 10, "x" * 10).inspect
puts SecureCompare.compare("abc", "xyz").inspect
