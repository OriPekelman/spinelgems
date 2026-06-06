require 'angael'

# Exercise Angael::Worker module inclusion and state methods
class MyWorker
  include Angael::Worker

  def work
    # no-op in tests
  end
end

w = MyWorker.new

# Initially not started (no pid)
puts w.stopped?        # true
puts w.started?        # false
puts w.stopping?       # nil/false (not yet set)

# inspect shows class name and pid (nil)
puts w.inspect         # #<JobWorker:... @pid=>

# Exercise Angael::Manager instantiation
m = Angael::Manager.new(MyWorker, 3)
puts m.workers.size    # 3
puts m.workers.all? { |w| w.is_a?(MyWorker) }  # true

# Manager with restart_after option
m2 = Angael::Manager.new(MyWorker, 2, [], restart_after: 10)
puts m2.workers.size   # 2

# Invalid restart_after raises ArgumentError
begin
  Angael::Manager.new(MyWorker, 1, [], restart_after: 0)
  puts "no error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# ProcessHelper#exit_status(nil) returns [nil, nil]
class PH
  include Angael::ProcessHelper
end
ph = PH.new
result = ph.exit_status(nil)
puts result.inspect    # [nil, nil]

# VERSION
puts Angael::VERSION   # 0.1.3

# LOOP_SLEEP_SECONDS
puts Angael::Manager::LOOP_SLEEP_SECONDS  # 1
