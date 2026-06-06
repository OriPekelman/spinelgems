require 'nagiosplugin'

# Concrete plugin: checks a numeric value against thresholds
class LoadCheck < Nagios::Plugin
  def initialize(load_value, warn_threshold, crit_threshold)
    @load = load_value
    @warn = warn_threshold
    @crit = crit_threshold
  end

  def critical?
    @load >= @crit
  end

  def warning?
    @load >= @warn
  end

  def ok?
    @load < @warn
  end

  def message
    "load=#{@load} warn=#{@warn} crit=#{@crit}"
  end
end

# Test EXIT_CODE constants
puts Nagios::Plugin::EXIT_CODE[:ok]
puts Nagios::Plugin::EXIT_CODE[:warning]
puts Nagios::Plugin::EXIT_CODE[:critical]
puts Nagios::Plugin::EXIT_CODE[:unknown]

# Test name() method - strips module prefix, upcases class name
p1 = LoadCheck.new(0.5, 1.0, 2.0)
puts p1.name

# Test status() priority: critical beats warning beats ok
p_crit = LoadCheck.new(3.0, 1.0, 2.0)
puts p_crit.status

p_warn = LoadCheck.new(1.5, 1.0, 2.0)
puts p_warn.status

p_ok = LoadCheck.new(0.5, 1.0, 2.0)
puts p_ok.status

# Test output() method
puts p_crit.output
puts p_warn.output
puts p_ok.output

# Test to_s delegates to output
puts p_crit.to_s == p_crit.output

# Plugin with all false => unknown status
class UnknownCheck < Nagios::Plugin
  def critical?; false; end
  def warning?;  false; end
  def ok?;       false; end
end
u = UnknownCheck.new
puts u.status

# Plugin without message method - output should be "NAME STATUS" only
class SimpleCheck < Nagios::Plugin
  def critical?; false; end
  def warning?;  false; end
  def ok?;       true;  end
end
s = SimpleCheck.new
puts s.status
puts s.output

# VERSION constant
puts Nagios::Plugin::VERSION
