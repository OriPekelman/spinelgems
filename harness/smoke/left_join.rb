require 'left_join'

# left_join is purely an ActiveRecord extension (adds left_join/left_joins
# to ActiveRecord::Base via module extension). There is no pure-Ruby logic
# beyond the module hierarchy. Without ActiveRecord the adapter block is
# skipped (guarded by `if defined?(ActiveRecord)`), so we verify the module
# structure that is always present.

puts LeftJoin.class
puts LeftJoin::Adapters.class
puts LeftJoin::Adapters::ActiveRecordAdapter.class
puts LeftJoin::Adapters::ActiveRecordAdapter.instance_method(:left_join).arity
puts LeftJoin::Adapters::ActiveRecordAdapter.instance_method(:left_joins).arity
# RAILS4_1_PLUS constant is only defined when ActiveRecord is present
puts defined?(LeftJoin::Adapters::RAILS4_1_PLUS).nil?
