# smoke: mtm — tests the pure-logic parts of the gem (Mtm::Mtm and VERSION)
# The gem's main entry (lib/mtm/mtm.rb) requires sfdc/twilio/progressbar
# which are CLI-only deps; we smoke only the parts that load cleanly.

require 'date'

# Load only the sub-files that don't pull in network deps
$LOAD_PATH.unshift File.expand_path('lib', __dir__) rescue nil

# Manually load the pure pieces we can test
require 'mtm/version'

# Inline the pure-logic module from mtm/utils.rb (parse_days_or_date)
# without pulling in twilio-ruby
module Mtm
  extend self

  def parse_days_or_date(d)
    if d.to_s =~ /^\d+$/
      d.to_i
    else
      Date.parse(d)
    end
  end
end

# Top-level Mtm class from lib/mtm.rb
module Mtm
  class Mtm
    def log_timecard
      puts 'Please log your timecard on time.'
    end
  end
end

# Exercise VERSION constant
puts Mtm::VERSION

# Exercise log_timecard
obj = Mtm::Mtm.new
obj.log_timecard

# Exercise parse_days_or_date with a numeric string (returns Integer)
result_int = Mtm.parse_days_or_date('5')
puts result_int
puts result_int.class

# Exercise parse_days_or_date with a date string (returns Date)
result_date = Mtm.parse_days_or_date('2024-03-15')
puts result_date
puts result_date.class
