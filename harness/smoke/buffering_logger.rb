require 'buffering_logger'
require 'buffering_logger/single_line_transform'
require 'stringio'

# --- Exercise BufferingLogger::SingleLineTransform ---
transform = BufferingLogger::SingleLineTransform.new
result = transform.call("line one\nline two\nline three\n")
puts result.chomp

transform2 = BufferingLogger::SingleLineTransform.new(replacement: ' | ')
result2 = transform2.call("alpha\nbeta\ngamma\n")
puts result2.chomp

# --- Exercise BufferingLogger::Buffer with a StringIO logdev ---
output = StringIO.new

# Minimal logdev wrapper: Buffer calls @logdev.write and @logdev.close
# Logger::LogDevice is overkill here; we need an object with write/close
class SimpleLogDev
  attr_reader :io
  def initialize; @io = StringIO.new; end
  def write(msg); @io.write(msg); end
  def close; @io.close; end
end

dev = SimpleLogDev.new
buf = BufferingLogger::Buffer.new(dev)

# Non-buffered write goes straight through
buf.write("direct\n")
puts dev.io.string.strip

# Buffered block accumulates and flushes at the end
dev2 = SimpleLogDev.new
buf2 = BufferingLogger::Buffer.new(dev2)

buf2.buffered do
  buf2.write("msg1\n")
  buf2.write("msg2\n")
  # nothing written yet during the block
  puts dev2.io.string.length == 0 ? "buffering:ok" : "buffering:fail"
end
# After block, flushed
puts dev2.io.string.strip

# Buffered with transform
dev3 = SimpleLogDev.new
buf3 = BufferingLogger::Buffer.new(dev3)
t = BufferingLogger::SingleLineTransform.new(replacement: '+')
buf3.buffered(transform: t) do
  buf3.write("x\n")
  buf3.write("y\n")
end
puts dev3.io.string.chomp

# --- Exercise BufferingLogger::Logger itself ---
log_io = StringIO.new
logger = BufferingLogger::Logger.new(log_io)
logger.formatter = ->(sev, _time, _prog, msg) { "#{sev}: #{msg}\n" }

logger.buffered do
  logger.info("hello")
  logger.warn("world")
end

log_output = log_io.string
puts log_output.include?("INFO: hello") ? "logger:info:ok" : "logger:info:fail"
puts log_output.include?("WARN: world") ? "logger:warn:ok" : "logger:warn:fail"
