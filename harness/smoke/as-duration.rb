require 'as-duration'

# Basic Duration creation via Numeric core_ext methods
d_secs = 30.seconds
puts d_secs.to_i   # => 30
puts d_secs.to_f   # => 30.0

d_mins = 5.minutes
puts d_mins.to_i   # => 300

d_hours = 2.hours
puts d_hours.to_i  # => 7200

d_days = 3.days
puts d_days.to_i   # => 259200

# Integer-only methods
d_months = 2.months
puts d_months.to_i # => 5184000

d_years = 1.year
puts d_years.to_i  # => 31536000

# Addition of durations
combined = 1.hour + 30.minutes
puts combined.to_i # => 5400

# Subtraction
diff = 2.hours - 30.minutes
puts diff.to_i     # => 5400

# Negation
neg = -5.minutes
puts neg.to_i      # => -300

# Comparison
puts (1.hour > 30.minutes)   # => true
puts (1.hour == 60.minutes)  # => true
puts (1.minute < 1.hour)     # => true

# parts inspection
d = 3.days
parts = d.parts
puts parts.inspect # => [[:days, 3]]

# advance a fixed Time (UTC, deterministic)
base_time = Time.utc(2024, 1, 1, 12, 0, 0)
advanced = 1.day.from(base_time)
puts advanced.year   # => 2024
puts advanced.month  # => 1
puts advanced.day    # => 2
puts advanced.hour   # => 12

# advance by months
base_time2 = Time.utc(2024, 3, 31, 0, 0, 0)
advanced2 = 1.month.from(base_time2)
puts advanced2.year  # => 2024
puts advanced2.month # => 4
puts advanced2.day   # => 30 (Apr has 30 days)

# until / before
earlier = 2.hours.until(base_time)
puts earlier.year    # => 2024
puts earlier.hour    # => 10

# weeks
d_weeks = 2.weeks
puts d_weeks.to_i    # => 1209600
