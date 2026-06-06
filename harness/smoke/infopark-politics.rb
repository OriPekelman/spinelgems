require 'logger'
require 'stringio'

# infopark-politics: load only the logger extension (politics/logger.rb),
# since static_queue_worker.rb requires 'dalli' which is unavailable.
# Tests the Logger#context context-tagging mixin the gem adds to stdlib Logger.

require 'politics/logger'

# context method is mixed into Logger
log = Logger.new(StringIO.new)
puts log.respond_to?(:context)   # => true

# tags start empty
puts log.send(:tags).inspect     # => []

# context pushes a tag, pops it after block
log.context("worker") do
  puts log.send(:tags).inspect   # => ["worker"]
  log.context("drb") do
    puts log.send(:tags).inspect # => ["worker", "drb"]
  end
  puts log.send(:tags).inspect   # => ["worker"]
end
puts log.send(:tags).inspect     # => []

# ensure block runs even on exception
begin
  log.context("boom") do
    raise "oops"
  end
rescue RuntimeError
end
puts log.send(:tags).inspect     # => [] (popped by ensure)

# tags are per-instance
log2 = Logger.new(StringIO.new)
log.context("a") do
  log2.context("b") do
    puts log.send(:tags).inspect   # => ["a"]
    puts log2.send(:tags).inspect  # => ["b"]
  end
end
