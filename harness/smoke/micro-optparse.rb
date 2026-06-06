require 'micro-optparse'

# Test 1: Basic option parsing with defaults
parser = Parser.new do |p|
  p.banner = "Usage: tool [options]"
  p.version = "1.0.0"
  p.option :verbose, "Enable verbose output", :default => false
  p.option :count, "Number of iterations", :default => 5
  p.option :name, "A name string", :default => "world"
end

# Parse with explicit arguments (not ARGV)
result = parser.process!([])
puts result[:verbose].inspect
puts result[:count].inspect
puts result[:name].inspect

# Test 2: Parse with some arguments overriding defaults
parser2 = Parser.new do |p|
  p.option :verbose, "Enable verbose output", :default => false
  p.option :count, "Number of iterations", :default => 5
  p.option :name, "A name string", :default => "world"
end

result2 = parser2.process!(["--verbose", "--count", "42", "--name", "spinel"])
puts result2[:verbose].inspect
puts result2[:count].inspect
puts result2[:name].inspect

# Test 3: short_from generates correct short flags
parser3 = Parser.new do |p|
  p.option :alpha, "First option", :default => false
  p.option :beta, "Second option", :default => false
  p.option :gamma, "Third option", :default => false
end

# Exercise short_from by processing — it's called during process!
result3 = parser3.process!(["-a", "-b"])
puts result3[:alpha].inspect
puts result3[:beta].inspect
puts result3[:gamma].inspect

# Test 4: value_in_set validation (valid value)
parser4 = Parser.new do |p|
  p.option :mode, "Run mode", :default => "fast", :value_in_set => ["fast", "slow", "normal"]
end
result4 = parser4.process!(["--mode", "slow"])
puts result4[:mode].inspect

# Test 5: value_satisfies validation (lambda)
parser5 = Parser.new do |p|
  p.option :size, "Size value", :default => 10, :value_satisfies => lambda {|v| v > 0}
end
result5 = parser5.process!(["--size", "99"])
puts result5[:size].inspect
