# Smoke for english-0.8.1
# The gem aliases global variables to English names.
# Exercise MATCH, PREMATCH, POSTMATCH, LAST_PAREN_MATCH after a regex.

"waterbuffalo" =~ /(buff)(al)/
puts $MATCH           # => "buffal"
puts $PREMATCH        # => "water"
puts $POSTMATCH       # => "o"
puts $LAST_PAREN_MATCH # => "al"

# Exercise OUTPUT_FIELD_SEPARATOR alias
$OUTPUT_FIELD_SEPARATOR = "-"
print "a", "b", "c"
puts
$OUTPUT_FIELD_SEPARATOR = nil

# Exercise INPUT_RECORD_SEPARATOR alias (just check it's readable as string)
puts $INPUT_RECORD_SEPARATOR.inspect # => "\n"
