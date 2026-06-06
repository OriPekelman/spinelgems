require 'ridgepole/mysql/partition'

# Test RangeParser with TransparentValueParser (integer ranges)
parser = Ridgepole::MySQL::Partition::RangeParser.new(
  between: (1..4),
  interval: 1
)

puts "alter_keyword: #{parser.alter_keyword}"
puts "partition_names: #{parser.partition_names.inspect}"
puts "partition_string:"
puts parser.partition_string

puts

# Test RangeParser with TimeValueParser (Time ranges)
t_start = Time.new(2024, 1, 1)
t_end   = Time.new(2024, 4, 1)
# 1 month ~30 days; use seconds directly
one_month = 60 * 60 * 24 * 31  # ~31 days

time_parser = Ridgepole::MySQL::Partition::RangeParser.new(
  between: (t_start..t_end),
  interval: one_month
)

puts "time partition_names: #{time_parser.partition_names.inspect}"

puts

# Test SQLBuilder wrapping an integer RangeParser
builder = Ridgepole::MySQL::Partition::SQLBuilder.new(
  "orders",
  "region_id",
  parser
)

sql = builder.to_sql
puts "sql:"
puts sql.strip
