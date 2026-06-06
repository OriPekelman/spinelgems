# capistrano-dotenv-tasks smoke
# Uses require_relative so Spinel can inline the Config class (no load path).
# Skips tasks.rb — it calls Capistrano DSL methods (set/namespace) that are
# only available inside the Capistrano runtime, not in isolation.
require_relative "lib/capistrano/dotenv/version"
require_relative "lib/capistrano/dotenv/config"

puts Capistrano::Dotenv::VERSION

# 1. Basic construction from .env-style content
raw = "DB_HOST=localhost\nDB_PORT=5432\nAPP_ENV=production\n"
cfg = Capistrano::Dotenv::Config.new(raw)

# variables are stored in a hash; sort for deterministic output
puts cfg.variables.sort.map { |k, v| "#{k}=#{v}" }.join(", ")

# 2. compile / to_s produces sorted KEY=VALUE lines
puts cfg.compile.chomp

# 3. set adds / overwrites a variable
cfg.set("DB_PORT", "5433")
cfg.set("REDIS_URL", "redis://localhost:6379")
puts cfg.variables["DB_PORT"]
puts cfg.variables["REDIS_URL"]

# 4. add parses additional KEY=VALUE strings; invalid lines ignored
cfg.add("LOG_LEVEL=debug", "not-a-valid-line", "TIMEOUT=30")
puts cfg.variables.key?("LOG_LEVEL") ? "LOG_LEVEL present" : "LOG_LEVEL missing"
puts cfg.variables.key?("TIMEOUT")   ? "TIMEOUT present"   : "TIMEOUT missing"
puts cfg.variables.key?("not-a-valid-line") ? "bad key present" : "bad key absent"

# 5. remove deletes named variables
cfg.remove("LOG_LEVEL", "TIMEOUT")
puts cfg.variables.key?("LOG_LEVEL") ? "LOG_LEVEL still there" : "LOG_LEVEL removed"

# 6. to_io returns a StringIO wrapping the compiled output
io = cfg.to_io
puts io.class
puts io.read.include?("REDIS_URL=redis://localhost:6379") ? "StringIO has REDIS_URL" : "StringIO missing REDIS_URL"

# 7. Empty config initialises cleanly
empty = Capistrano::Dotenv::Config.new
puts empty.variables.empty? ? "empty variables ok" : "unexpected variables"
puts empty.compile == "\n" ? "empty compile ok" : "empty compile wrong"
