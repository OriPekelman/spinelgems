# rwdschedule 1.02 — RubyWebDialogs-based scheduling application.
# lib/rwdschedule.rb does not exist; the gem ships lib/temp.rb ("this file does
# nothing").  All real logic is in code/superant.com.schedule/*.rb as instance
# methods of a RWDialog GUI subclass — not loadable without the ev/rwd framework.
#
# We exercise the self-contained data-formatting logic that mirrors
# saveeventrecord (datetime string building) and loadeventrecord (datetime
# string parsing), using only Ruby stdlib string operations.

# 1. Version constant (value from configuration/rwdschedule.dist)
RwdScheduleVersion = "1.02"
puts "version:#{RwdScheduleVersion}"

# 2. saveeventrecord datetime-string building logic
year   = "2005"
month  = "01"
day    = "11"
bhour  = "09"
bmin   = "30"
ehour  = "10"
emin   = "00"
summary     = "Team Meeting"
description = "Weekly sync"
location    = "Conference Room A"

# mirrors: newdata = a_eventyear + a_eventmonth + a_eventday + "T" + ...
newdata = year + month + day + "T" + bhour + bmin + "00"
newdata = newdata + "\n" + year + month + day + "T" + ehour + emin + "00"
newdata = newdata + "\n" + summary + "\n" + description + "\n" + location

puts "event_lines:#{newdata.lines.count}"
puts "start_dt:#{newdata.lines[0].chomp}"
puts "end_dt:#{newdata.lines[1].chomp}"
puts "summary:#{newdata.lines[2].chomp}"

# 3. loadeventrecord datetime-parsing logic (slice on the start line)
eventdatetime = newdata.lines[0].chomp
puts "parsed_year:#{eventdatetime.slice(0..3)}"
puts "parsed_month:#{eventdatetime.slice(4..5)}"
puts "parsed_day:#{eventdatetime.slice(6..7)}"
puts "parsed_hour:#{eventdatetime.slice(9..10)}"
puts "parsed_minute:#{eventdatetime.slice(11..12)}"

# 4. filleventdatesname / fillicseventdatesname gsub logic
puts "sch_base:#{"20050111.sch".gsub(/\.sch$/, "")}"
puts "ics_base:#{"20050111.ics".gsub(/\.ics$/, "")}"

# 5. rwdschedulehelpaboutsetup return value
helpabout = ["RwdSchedule", "(c) 2004,2005 Steven Gibson ", "Version #{RwdScheduleVersion}"]
puts "helpabout_app:#{helpabout[0]}"
puts "helpabout_version:#{helpabout[2]}"
