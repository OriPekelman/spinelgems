require 'rubysl/strscan'

# 1. Version constant from the module
puts RubySL::StringScanner::VERSION

# 2. StringScanner::Version and Id constants (defined in the pure-Ruby impl)
puts StringScanner::Version
puts StringScanner::Id

# 3. Construction and non-scanning accessors
ss = StringScanner.new("hello world foo")
puts ss.string.inspect
puts ss.pos
puts ss.eos?
puts ss.rest_size

# 4. peek (reads ahead without advancing position)
puts ss.peek(5).inspect
puts ss.pos          # still 0

# 5. bol? at start of string
puts ss.bol?

# 6. pos= assignment
ss.pos = 6
puts ss.pos
puts ss.rest.inspect

# 7. rest? predicate
puts ss.rest?

# 8. reset
ss.reset
puts ss.pos
puts ss.eos?

# 9. terminate
ss2 = StringScanner.new("abc")
ss2.terminate
puts ss2.pos
puts ss2.eos?

# 10. string= reassignment
ss2.string = "xyz"
puts ss2.string.inspect
puts ss2.pos

# 11. ScanError is defined
puts ScanError.superclass
