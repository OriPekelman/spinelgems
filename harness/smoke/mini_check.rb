# Drive MiniCheck::VERSION (autoloaded from mini_check/version.rb)
puts MiniCheck::VERSION

# Build a Check object with a block but don't call run (avoids Benchmark)
c = MiniCheck::Check.new("db") { true }
puts c.name
puts c.healthy?.inspect
puts c.exception.inspect

# ChecksCollection basics
col = MiniCheck::ChecksCollection.new
col.register("svc") { true }
puts col.size
puts col.healthy?.inspect
