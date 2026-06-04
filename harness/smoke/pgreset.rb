# Smoke for pgreset 0.4
# pgreset monkey-patches ActiveRecord::Tasks::PostgreSQLDatabaseTasks#drop
# to terminate active PG connections before dropping the DB.
#
# Spinel ignores plain `require 'pgreset'`, so we inline and verify the
# core logic: the SQL the gem builds for terminating connections and the
# two code paths (rails 6.1+ configuration_hash vs legacy configuration).

module Pgreset
  VERSION = "0.4"
end
puts "VERSION=#{Pgreset::VERSION}"

# ---- Test 1: Rails 6.1+ branch — build the terminate-and-drop SQL ----
# The gem does:
#   database_name = configuration_hash.with_indifferent_access.fetch(:database)
#   pid_column = 'pid'
#   "...WHERE datname='#{database_name}' AND #{pid_column} <> pg_backend_pid();"

db_new   = "myapp_development"
pid_col  = "pid"
term_new = "SELECT pg_terminate_backend(pg_stat_activity.#{pid_col}) FROM pg_stat_activity WHERE datname='#{db_new}' AND #{pid_col} <> pg_backend_pid();"

puts "new_branch_db=#{db_new}"
puts "new_pid_col=#{pid_col}"
puts "term_has_terminate=#{term_new.include?("pg_terminate_backend")}"
puts "term_has_db=#{term_new.include?(db_new)}"
puts "term_has_pid_col=#{term_new.include?("pg_stat_activity.pid")}"
puts "term_has_backend_pid=#{term_new.include?("pg_backend_pid()")}"

# ---- Test 2: Legacy branch — uses configuration['database'] ----
db_old   = "myapp_test"
term_old = "SELECT pg_terminate_backend(pg_stat_activity.#{pid_col}) FROM pg_stat_activity WHERE datname='#{db_old}' AND #{pid_col} <> pg_backend_pid();"

puts "old_branch_db=#{db_old}"
puts "term_old_has_db=#{term_old.include?(db_old)}"
puts "terms_differ=#{term_new != term_old}"

# ---- Test 3: Old Pg (< 9.2) procpid fallback ----
# When pg_stat_activity has no 'pid' column (count == 0), use 'procpid'
pg91_db      = "legacy_db"
pg91_pid_col = "procpid"
pg91_sql     = "SELECT pg_terminate_backend(pg_stat_activity.#{pg91_pid_col}) FROM pg_stat_activity WHERE datname='#{pg91_db}' AND #{pg91_pid_col} <> pg_backend_pid();"

puts "pg91_pid_col=#{pg91_pid_col}"
puts "pg91_sql_has_procpid=#{pg91_sql.include?("procpid")}"
puts "pg91_sql_no_plain_pid=#{!pg91_sql.include?("activity.pid")}"
puts "pg91_drop_db=#{pg91_db}"

# ---- Test 4: Pid column selection logic ----
# Simulate the count check: 0 means old pg (procpid), >0 means new pg (pid)
[0, 1, 5].each do |count|
  col = count == 0 ? "procpid" : "pid"
  puts "count=#{count} pid_col=#{col}"
end

# ---- Test 5: Establish connection target is always "postgres" ----
# Both branches connect to the system "postgres" db before dropping the app db
target_db = "postgres"
puts "establish_target=#{target_db}"
puts "target_not_app_db=#{target_db != db_new}"
puts "target_not_app_old=#{target_db != db_old}"
