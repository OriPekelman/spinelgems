require 'English'

# Test 1: $MATCH ($&), $PREMATCH ($`), $POSTMATCH ($') after a regex match
"waterbuffalo" =~ /buff/
puts $MATCH        # => "buff"
puts $PREMATCH     # => "water"
puts $POSTMATCH    # => "alo"

# Test 2: $LAST_PAREN_MATCH ($+) — highest-numbered capture group
"cat" =~ /(c|a)(t|z)/
puts $LAST_PAREN_MATCH  # => "t"

# Test 3: $LAST_MATCH_INFO ($~) — MatchData object
"hello world" =~ /(\w+)\s+(\w+)/
md = $LAST_MATCH_INFO
puts md[1]   # => "hello"
puts md[2]   # => "world"

# Test 4: $INPUT_RECORD_SEPARATOR ($/) — default newline
puts $INPUT_RECORD_SEPARATOR.inspect  # => "\n"

# Test 5: $OUTPUT_FIELD_SEPARATOR ($,) — default nil
puts $OUTPUT_FIELD_SEPARATOR.inspect  # => "nil"

# Test 6: $PID / $PROCESS_ID — both aliases for $$
puts ($PID == $$)           # => true
puts ($PROCESS_ID == $$)    # => true

# Test 7: $ARGV alias for $*
puts $ARGV.class   # => Array
