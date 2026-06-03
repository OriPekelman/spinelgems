# frozen_string_literal: true
# Smoke for english-0.8.1
# The gem aliases global variables to English names.
require 'English'

# Exercise $MATCH ($&), $PREMATCH ($`), $POSTMATCH ($'), $LAST_PAREN_MATCH ($+)
"waterbuffalo" =~ /(buff)(al)/
puts $MATCH             # => buffal
puts $PREMATCH          # => water
puts $POSTMATCH         # => o
puts $LAST_PAREN_MATCH  # => al

# Exercise $LAST_MATCH_INFO ($~)
puts $LAST_MATCH_INFO[1]  # => buff

# Exercise $OUTPUT_FIELD_SEPARATOR ($,) alias
$OUTPUT_FIELD_SEPARATOR = "-"
print "a", "b", "c"
puts
$OUTPUT_FIELD_SEPARATOR = nil

# Exercise $ERROR_INFO ($!) via rescue
begin
  raise "test error"
rescue => _e
  puts $ERROR_INFO.message  # => test error
end

# Exercise $INPUT_RECORD_SEPARATOR ($/) alias (readable as string)
puts $INPUT_RECORD_SEPARATOR.inspect  # => "\n"

# Exercise $PID / $PROCESS_ID ($$)
puts $PID.is_a?(Integer) && $PID > 0  # => true
puts $PROCESS_ID == $PID              # => true
