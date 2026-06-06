require 'kronic'
require 'date'

# Use a fixed reference date so output is deterministic
REF = Date.new(2024, 6, 15)  # Saturday

# --- Kronic.format ---
# Today / Yesterday / Tomorrow
puts Kronic.format(REF,       today: REF)   # => "Today"
puts Kronic.format(REF - 1,   today: REF)   # => "Yesterday"
puts Kronic.format(REF + 1,   today: REF)   # => "Tomorrow"

# This <weekday> (2-7 days out)
puts Kronic.format(REF + 2,   today: REF)   # => "This Monday"
puts Kronic.format(REF + 5,   today: REF)   # => "This Thursday"

# Last <weekday> (2-7 days back)
puts Kronic.format(REF - 2,   today: REF)   # => "Last Thursday"
puts Kronic.format(REF - 7,   today: REF)   # => "Last Saturday"

# Far future / far past → full date
puts Kronic.format(REF + 10,  today: REF)   # => "25 June 2024"
puts Kronic.format(Date.new(2010, 9, 19), today: REF)  # => "19 September 2010"

# --- Kronic.parse (with a fixed reference) ---
# Today / yesterday / tomorrow keywords
puts Kronic.parse('today').class           # => Date
puts Kronic.parse('yesterday').class       # => Date
puts Kronic.parse('tomorrow').class        # => Date

# Exact ISO dates (deterministic regardless of current date)
puts Kronic.parse('2024-06-15').to_s       # => "2024-06-15"
puts Kronic.parse('2010-09-04').to_s       # => "2010-09-04"
puts Kronic.parse('2010-9-4').to_s         # => "2010-09-04"

# Named month formats (with explicit year → fully deterministic)
puts Kronic.parse('14 Sep 2022').to_s      # => "2022-09-14"
puts Kronic.parse('Sep 14 2022').to_s      # => "2022-09-14"
puts Kronic.parse('14 September 2022').to_s # => "2022-09-14"

# Nil for unparseable input
puts Kronic.parse('not a date').inspect    # => nil
puts Kronic.parse('').inspect              # => nil
