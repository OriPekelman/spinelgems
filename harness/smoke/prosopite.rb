require 'prosopite'

# 1. Module constants
puts Prosopite::DEFAULT_ALLOW_LIST.length
puts Prosopite::DEFAULT_ALLOW_LIST[1]
puts Prosopite::NPlusOneQueriesError.superclass

# 2. enabled?/disabled? toggle
Prosopite.enabled = true
puts Prosopite.enabled?
puts Prosopite.disabled?

Prosopite.enabled = false
puts Prosopite.enabled?
puts Prosopite.disabled?

# Reset to enabled
Prosopite.enabled = true

# 3. scan? before any scan started (thread-local not set)
puts Prosopite.scan?

# 4. mysql_fingerprint — normalises SQL literals → '?'
puts Prosopite.mysql_fingerprint("SELECT * FROM users WHERE id = 42")
puts Prosopite.mysql_fingerprint("SELECT * FROM orders WHERE user_id IN (1, 2, 3)")
puts Prosopite.mysql_fingerprint("SELECT name FROM customers WHERE status = 'active' AND age > 25")
puts Prosopite.mysql_fingerprint("USE mydb")
puts Prosopite.mysql_fingerprint("SELECT * FROM t WHERE x = 1 LIMIT 5, 10")
puts Prosopite.mysql_fingerprint("SELECT * FROM t ORDER BY name ASC")

# 5. ignore_query? with patterns and strings
Prosopite.ignore_queries = [/SCHEMA/, "SELECT 1"]
puts Prosopite.ignore_query?("SELECT * FROM users")
puts Prosopite.ignore_query?("SCHEMA load")
puts Prosopite.ignore_query?("SELECT 1")

# 6. red — ANSI escape wrapping
colored = Prosopite.red("N+1 detected")
puts colored.include?("\e[91m")
puts colored.include?("N+1 detected")
puts colored.include?("\e[0m")

# 7. allow_list= deprecation (prints notice, writes to allow_stack_paths)
Prosopite.allow_list = [/some\/path/]
puts Prosopite.allow_stack_paths.length

# 8. pause/resume without active scan
Prosopite.pause do
  puts Prosopite.scan?
end
puts Prosopite.scan?

# 9. raise? and local_raise
puts Prosopite.raise?
Prosopite.start_raise
puts Prosopite.raise?
Prosopite.stop_raise
puts Prosopite.raise?
