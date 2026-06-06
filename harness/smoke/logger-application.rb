require 'logger-application'
require 'stringio'

# Test 1: Check version constant
puts "version: #{Logger::Application::VERSION}"

# Test 2: Check appname attribute reader
class MyApp < Logger::Application
  def initialize(name)
    super(name)
  end

  def run
    log(INFO, "running")
    42
  end
end

app = MyApp.new("TestApp")
puts "appname: #{app.appname}"

# Test 3: set_log to a StringIO so we can capture log output
log_output = StringIO.new
app.set_log(log_output)

# Test 4: check level= method
app.level = Logger::WARN
puts "level set: ok"

# Test 5: exercise the log method (should not write because level < WARN)
app.log(Logger::DEBUG, "this should not appear")
log_output.rewind
output_before = log_output.read
puts "debug suppressed: #{output_before.empty?}"

# Test 6: log at WARN should appear
log_output.rewind
log_output.truncate(0)
app.log(Logger::WARN, "something warned")
log_output.rewind
warn_output = log_output.read
puts "warn logged: #{warn_output.include?('something warned')}"

# Test 7: Logger::Application includes Logger::Severity
puts "has severity constants: #{Logger::Application.include?(Logger::Severity)}"

# Test 8: logger accessor returns the Logger instance
puts "logger class: #{app.logger.class}"
