require 'time_date_helpers'
require 'date'

# humanize_time: ampm (default) and 24h modes
t = Time.new(2024, 6, 15, 14, 30, 45)
puts humanize_time(t)                               # "02:30 pm"
puts humanize_time(t, ampm: true, with_seconds: true)  # "02:30:45 pm"
puts humanize_time(t, ampm: false)                  # "14:30"
puts humanize_time(t, ampm: false, with_seconds: true) # "14:30:45"
puts humanize_time(nil).inspect                     # nil
puts humanize_time("not a time").inspect            # nil

# round_minutes: round up (default) and round down
t2 = Time.new(2024, 3, 10, 9, 22, 0)
r_up   = round_minutes(t2)                          # up to 15-min boundary => :30
r_down = round_minutes(t2, direction: :down)        # down => :15
puts "#{r_up.hour}:#{format('%02d', r_up.min)}"    # 9:30
puts "#{r_down.hour}:#{format('%02d', r_down.min)}" # 9:15

# round_minutes: already on a boundary
t3 = Time.new(2024, 3, 10, 9, 15, 0)
r3 = round_minutes(t3)
puts "#{r3.hour}:#{format('%02d', r3.min)}"        # 9:15

# round_minutes: bad increment
puts round_minutes(t2, increment: 61).inspect      # nil
puts round_minutes(t2, increment: 0).inspect       # nil
puts round_minutes(t2, increment: 3.5).inspect     # nil (not Integer)

# humanize_date: calendar style with Date
d = Date.new(2024, 6, 5)
puts humanize_date(d)                              # "06/05/2024"
puts humanize_date(d, style: :calendar)           # "06/05/2024"

# humanize_date with Time object
puts humanize_date(t)                              # "06/15/2024"

# humanize_date: nil and wrong type
puts humanize_date(nil).inspect                    # nil
puts humanize_date("2024-06-05").inspect           # nil
