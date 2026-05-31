# Test choose_date_format — pure string-to-string, no Time needed
puts DateFormat.choose_date_format("ISO_8601_FORMAT")
puts DateFormat.choose_date_format("SHORT_DATE")
puts DateFormat.choose_date_format("MEDIUM_DATE")
puts DateFormat.choose_date_format("DAY_IN_MONTH")
puts DateFormat.choose_date_format("UNKNOWN_FORMAT")

# Test change_to with a fixed Time (nil/empty paths)
puts DateFormat.change_to(nil, "ISO_8601_FORMAT")
puts DateFormat.change_to("", "ISO_8601_FORMAT")

# Test choose_time_difference_format (pure arithmetic, no Time.now)
puts DateFormat.choose_time_difference_format(90061, 1, 1, 1, 1, "DAY_ONLY")
puts DateFormat.choose_time_difference_format(90061, 1, 1, 1, 1, "SECOND_ONLY")
puts DateFormat.choose_time_difference_format(3600, 0, 1, 0, 0, "HOUR_ONLY")
