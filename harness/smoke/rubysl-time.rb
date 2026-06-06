require 'time'

# Time.zone_offset: named zones from ZoneOffset hash
puts Time.zone_offset('UTC')      # => 0
puts Time.zone_offset('EST')      # => -18000
puts Time.zone_offset('PST')      # => -28800
puts Time.zone_offset('+05:30')   # => 19800

# Time.xmlschema / Time#xmlschema (iso8601)
t = Time.xmlschema('2000-10-31T12:00:00Z')
puts t.utc?                       # => true
puts t.xmlschema                  # => 2000-10-31T12:00:00Z
puts t.iso8601                    # => 2000-10-31T12:00:00Z
puts t.xmlschema(3)               # => 2000-10-31T12:00:00.000Z

# Time.xmlschema with timezone offset
t2 = Time.xmlschema('2000-10-31T07:00:00-05:00')
puts t2.utc.xmlschema             # => 2000-10-31T12:00:00Z

# Time#rfc2822 / Time#rfc822 formatting
t3 = Time.utc(2011, 10, 5, 22, 26, 12)
puts t3.rfc2822                   # => Wed, 05 Oct 2011 22:26:12 -0000
puts t3.rfc822                    # same alias

# Time.rfc2822 parsing
t4 = Time.rfc2822('Wed, 05 Oct 2011 22:26:12 +0000')
puts t4.utc.xmlschema             # => 2011-10-05T22:26:12Z

# Time#httpdate formatting (always UTC)
t5 = Time.utc(2011, 10, 6, 2, 26, 12)
puts t5.httpdate                  # => Thu, 06 Oct 2011 02:26:12 GMT

# Time.httpdate parsing
t6 = Time.httpdate('Thu, 06 Oct 2011 02:26:12 GMT')
puts t6.utc.xmlschema             # => 2011-10-06T02:26:12Z

# Time.zone_offset with numeric offset strings
puts Time.zone_offset('-08:00')   # => -28800
puts Time.zone_offset('+0530')    # => 19800
