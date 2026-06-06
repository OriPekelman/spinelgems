# Smoke for adiwg-mdtranslator
# Exercises AdiwgDateTimeFun (pure-Ruby datetime utilities) and VERSION.
# The full translate() pipeline depends on adiwg-mdcodes, json-schema, nokogiri,
# etc., which are unavailable at Spinel compile-time (plain require is ignored);
# so we target the self-contained internal module that ships with this gem.

require 'adiwg/mdtranslator/version'
require 'adiwg/mdtranslator/internal/module_dateTimeFun'

puts "version: #{ADIWG::Mdtranslator::VERSION}"

# --- dateTimeFromString ---

dt1, r1 = AdiwgDateTimeFun.dateTimeFromString('2023-05-15T10:30:00')
puts "dt1 resolved as: #{r1}"
puts "dt1 date part: #{dt1.strftime('%Y-%m-%d')}"

dt2, r2 = AdiwgDateTimeFun.dateTimeFromString('2023-05-15T10:30:00Z')
puts "dt2 resolved as: #{r2}"

dt3, r3 = AdiwgDateTimeFun.dateTimeFromString('2023-05')
puts "dt3 resolved as: #{r3}"

dt4, r4 = AdiwgDateTimeFun.dateTimeFromString('1999')
puts "dt4 resolved as: #{r4}"

_, rErr = AdiwgDateTimeFun.dateTimeFromString('2023-99-99')
puts "invalid date resolution: #{rErr}"

# --- stringDateFromDateTime ---

puts "date string: #{AdiwgDateTimeFun.stringDateFromDateTime(dt1, r1)}"
puts "date YM: #{AdiwgDateTimeFun.stringDateFromDateTime(dt3, r3)}"
puts "date Y: #{AdiwgDateTimeFun.stringDateFromDateTime(dt4, r4)}"

# --- stringDateTimeFromDateTime ---

dts = AdiwgDateTimeFun.stringDateTimeFromDateTime(dt2, r2)
puts "datetime with tz: #{dts}"

dts2 = AdiwgDateTimeFun.stringDateTimeFromDateTime(dt1, r1)
puts "datetime no tz: #{dts2}"

# --- stringTimeFromDateTime ---

t = AdiwgDateTimeFun.stringTimeFromDateTime(dt2, r2)
puts "time with tz: #{t}"

t2 = AdiwgDateTimeFun.stringTimeFromDateTime(dt1, r1)
puts "time no tz: #{t2}"

# --- stringDateFromDateObject ---

obj1 = {date: dt1, dateTime: nil, dateResolution: r1}
puts "date from obj: #{AdiwgDateTimeFun.stringDateFromDateObject(obj1)}"

obj2 = {date: nil, dateTime: dt2, dateResolution: r2}
puts "date from obj (dt fallback): #{AdiwgDateTimeFun.stringDateFromDateObject(obj2)}"

# --- writeDuration ---

dur1 = {years: 1, months: 3, days: 0, hours: 12, minutes: 0, seconds: 0}
puts "duration P1Y3MT12H: #{AdiwgDateTimeFun.writeDuration(dur1)}"

dur2 = {years: 0, months: 0, days: 5, hours: 0, minutes: 30, seconds: 45}
puts "duration P5DT30M45S: #{AdiwgDateTimeFun.writeDuration(dur2)}"

dur3 = {years: 2, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0}
puts "duration P2Y: #{AdiwgDateTimeFun.writeDuration(dur3)}"

# --- translate() - nil file path: pure-Ruby early exit, no external deps triggered ---
# The top-level require chain for adiwg-mdtranslator loads mdReaders/mdWriters (pure Ruby),
# module_dateTimeFun (stdlib date only) and version — all dependency-free.
# Passing file: nil triggers the early-return branch before any reader is required.

require 'adiwg/mdtranslator'
r = ADIWG::Mdtranslator.translate(file: nil, reader: 'mdJson')
puts "translate nil file pass: #{r[:readerStructurePass]}"
puts "translate nil file msg: #{r[:readerStructureMessages].first}"
# version not set in early-return path — confirming the branch taken
puts "translate nil file version_set: #{!r[:translatorVersion].nil?}"
