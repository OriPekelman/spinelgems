# frozen_string_literal: true

require 'pp_sql'

# pp_sql wraps an SQL formatter (anbt-sql-formatter) behind PpSql::ToSqlBeautify.
# The SQL formatting itself requires an external dep; here we test the module
# structure, config accessors, and the ToSqlBeautify code path that does NOT
# call the formatter (rewrite_to_sql_method=false → to_sql returns self).

# 1. Module-level config defaults
puts "rewrite_to_sql:   #{PpSql.rewrite_to_sql_method}"
puts "rails_formatting: #{PpSql.add_rails_logger_formatting}"
puts "white_space:      #{PpSql::WHITE_SPACE.inspect}"

# 2. Mix ToSqlBeautify into a String subclass (as documented in README)
class SqlString < String
  include PpSql::ToSqlBeautify
end

puts "ancestors_ok: #{SqlString.ancestors.include?(PpSql::ToSqlBeautify)}"

# 3. With rewrite_to_sql_method = false, to_sql returns self (no external dep)
PpSql.rewrite_to_sql_method = false
raw = 'SELECT id, name FROM users WHERE active = 1'
s = SqlString.new(raw)
result = s.to_sql
puts "to_sql_is_self: #{result.equal?(s)}"
puts "to_sql_value:   #{result}"

# 4. Config mutation round-trips
PpSql.add_rails_logger_formatting = false
puts "rails_off: #{PpSql.add_rails_logger_formatting}"
PpSql.rewrite_to_sql_method = true
puts "rewrite_on: #{PpSql.rewrite_to_sql_method}"

# 5. A second independent string subclass confirms include works on fresh class
class QueryString < String
  include PpSql::ToSqlBeautify
end
PpSql.rewrite_to_sql_method = false
q = QueryString.new('SELECT COUNT(*) FROM orders')
puts "query_to_sql: #{q.to_sql}"
