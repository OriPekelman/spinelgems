# Smoke: migrations_watchdog
# Exercise MigrationsWatchdog.check with pure Ruby paths — no external deps

# No migration files, only .rb files — should return true
puts MigrationsWatchdog.check(["app/models/user.rb", "app/controllers/home.rb"]).inspect

# Only migration files — should return true
puts MigrationsWatchdog.check(["db/migrate/20210101_create_users.rb"]).inspect

# Only structure.sql — should return true
puts MigrationsWatchdog.check(["db/structure.sql"]).inspect

# Empty list — should return true
puts MigrationsWatchdog.check([]).inspect

# Check error class ancestry
puts MigrationsWatchdog::Error.superclass.name
