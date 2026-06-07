require 'migration_sql'

# The gem is a Rails/ActiveRecord rake-task plugin; all meaningful code
# (Railtie, rake tasks) requires Rails and ActiveRecord which are not
# available here. Smoke the module structure and VERSION that are
# unconditionally defined.

puts MigrationSql::VERSION

# Verify the module is present and has the expected structure
puts MigrationSql.is_a?(Module)

# The rake file's SQL-detection regex is the gem's core logic;
# replicate it standalone to exercise the pattern.
sql_filter = /^(create|alter|drop|insert|delete|update)/i

statements = [
  "CREATE TABLE users (id int);",
  "ALTER TABLE users ADD COLUMN name varchar(255);",
  "DROP TABLE users;",
  "INSERT INTO users VALUES (1);",
  "DELETE FROM users WHERE id=1;",
  "UPDATE users SET name='foo' WHERE id=1;",
  "SELECT * FROM users;",
  "BEGIN;",
  "COMMIT;",
]

statements.each do |sql|
  match = sql_filter.match(sql) ? "DDL/DML" : "other"
  puts "#{sql.split.first.upcase}: #{match}"
end
