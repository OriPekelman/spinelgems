# Test the Cloc module's warn accessor (defined directly in cloc.rb)
puts Cloc.respond_to?(:warn)
puts Cloc.respond_to?(:warn=)
puts Cloc.warn.inspect
Cloc.warn = true
puts Cloc.warn.inspect
Cloc.warn = false
puts Cloc.warn.inspect
puts Cloc.is_a?(Module)
