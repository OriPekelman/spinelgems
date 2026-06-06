# Smoke test for capistrano-measure
# Tests Timer and Event logic directly (no capistrano/colorized_string needed)
# The main entry point requires capistrano; we load only the isolated sub-modules.

require 'capistrano/measure/version'
require 'capistrano/measure/error'
require 'capistrano/measure/timer'

puts Capistrano::Measure::VERSION

# --- Timer: start/stop a single event ---
timer = Capistrano::Measure::Timer.new
timer.start("deploy")
timer.stop("deploy")

events = timer.report_events.to_a
puts events.size          # => 1 (start collapsed, only stop remains)
ev = events.first
puts ev.name              # => "deploy"
puts ev.action            # => stop
puts ev.indent            # => 0
puts ev.elapsed_time >= 0 # => true

# --- Event#id and eq? ---
e1 = Capistrano::Measure::Timer::Event.new("task", :start, Time.now, 0)
e2 = Capistrano::Measure::Timer::Event.new("task", :start, Time.now, 0)
e3 = Capistrano::Measure::Timer::Event.new("other", :start, Time.now, 0)
puts e1.id                # => "task_0"
puts e1.eq?(e2)           # => true
puts e1.eq?(e3)           # => false
puts e1.start?            # => true

# --- Nested events ---
timer2 = Capistrano::Measure::Timer.new
timer2.start("outer")
timer2.start("inner")
timer2.stop("inner")
timer2.stop("outer")

names = timer2.report_events.map(&:name)
puts names.inspect        # => ["outer", "inner", "outer"]

# --- Error on mismatched stop ---
timer3 = Capistrano::Measure::Timer.new
timer3.start("alpha")
begin
  timer3.stop("beta")
rescue Capistrano::Measure::Error => e
  puts e.class            # => Capistrano::Measure::Error
  puts e.message.include?("beta") # => true
end

# --- Error on report with open events ---
timer4 = Capistrano::Measure::Timer.new
timer4.start("unclosed")
begin
  timer4.report_events.to_a
rescue Capistrano::Measure::Error => e
  puts e.class            # => Capistrano::Measure::Error
  puts e.message.include?("unclosed") # => true
end
