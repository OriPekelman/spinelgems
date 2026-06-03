# frozen_string_literal: true

# Smoke for business-period (gem entry point: business-period.rb)
require 'business-period'
require 'date'

# Configure with Estonian locale and Mon-Fri work days
BusinessPeriod::Config.locale = 'et'
BusinessPeriod::Config.work_days = [1, 2, 3, 4, 5]

b = BusinessPeriod::Base.new

# holiday_month_with_day: formats a month+day key used for holiday lookup
puts b.holiday_month_with_day(1, 1)   # => 1_1
puts b.holiday_month_with_day(12, 25) # => 12_25

# day_is_holiday?: checks against loaded YAML holiday config
jan1  = Date.new(2024, 1, 1)   # New Year's Day (Estonian holiday)
jan2  = Date.new(2024, 1, 2)   # Regular Tuesday
feb24 = Date.new(2024, 2, 24)  # Independence Day (Estonian holiday)
puts b.day_is_holiday?(jan1)   # => true
puts b.day_is_holiday?(jan2)   # => false
puts b.day_is_holiday?(feb24)  # => true

# Days.call: compute business-day indices for a fixed primary_day
primary = Time.new(2024, 1, 2, 0, 0, 0)
result = BusinessPeriod::Days.call(0, 3, primary_day: primary)
puts result[:from_date].to_s  # => 2024-01-02
puts result[:to_date].to_s    # => 2024-01-05

# Invalid params return empty array
puts BusinessPeriod::Days.call(5, 2, {}).inspect  # => [] (from > to)
puts BusinessPeriod::Days.call(-1, 3, {}).inspect # => [] (negative)
