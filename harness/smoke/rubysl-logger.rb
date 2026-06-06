require 'rubysl/logger'
require 'stringio'

# 1. Severity constants
puts Logger::DEBUG   # => 0
puts Logger::INFO    # => 1
puts Logger::WARN    # => 2
puts Logger::ERROR   # => 3
puts Logger::FATAL   # => 4
puts Logger::UNKNOWN # => 5

# 2. Level predicate methods
log = Logger.new(StringIO.new)
log.level = Logger::WARN

puts log.debug?  # => false
puts log.info?   # => false
puts log.warn?   # => true
puts log.error?  # => true
puts log.fatal?  # => true

# 3. Custom formatter — capture output deterministically
buf = StringIO.new
log2 = Logger.new(buf)
log2.level = Logger::DEBUG
log2.formatter = proc { |severity, _time, progname, msg|
  "#{severity}|#{progname}|#{msg}\n"
}
log2.progname = 'TestApp'
log2.info("hello world")
log2.warn("low disk space")
log2.error { "computed: #{1 + 1}" }

lines = buf.string.lines
puts lines[0].chomp   # INFO|TestApp|hello world
puts lines[1].chomp   # WARN|TestApp|low disk space
puts lines[2].chomp   # ERROR|TestApp|computed: 2

# 4. Level filtering: DEBUG message suppressed at WARN level
buf2 = StringIO.new
log3 = Logger.new(buf2)
log3.level = Logger::WARN
log3.formatter = proc { |sev, _t, _p, msg| "#{sev}:#{msg}\n" }
log3.debug("invisible")
log3.warn("visible")
output = buf2.string.lines
puts output.length   # => 1 (only the warn line)
puts output[0].chomp # WARN:visible

# 5. sev_threshold alias
log4 = Logger.new(StringIO.new)
log4.sev_threshold = Logger::ERROR
puts log4.level  # => 3
