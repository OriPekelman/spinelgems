# smoke: n_plus_one_control
# Exercises constants and config defined directly in the main file (no sub-requires needed).

puts NPlusOneControl::QUERY_PART_TO_TYPE.keys.sort.join(",")
puts NPlusOneControl::QUERY_PART_TO_TYPE["from"]
puts NPlusOneControl::QUERY_PART_TO_TYPE["insert into"]
puts NPlusOneControl::QUERY_PART_TO_TYPE["update"]
puts NPlusOneControl::QUERY_PART_TO_TYPE["delete from"]
puts NPlusOneControl.default_scale_factors.inspect
puts NPlusOneControl.show_table_stats.inspect
puts NPlusOneControl.ignore_cached_queries.inspect
