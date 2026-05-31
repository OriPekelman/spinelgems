# Thunder::Boolean is a simple marker class
puts Thunder::Boolean.superclass

# Build a class that includes Thunder and uses the DSL
class MyCLI
  include Thunder

  desc "greet NAME", "say hello"
  def greet(name)
    puts "Hello, #{name}!"
  end

  desc "add A B", "add two numbers"
  option :verbose, type: Thunder::Boolean, desc: "be verbose"
  def add(a, b, opts = {})
    puts a.to_i + b.to_i
  end
end

# Inspect the registered commands (sorted for determinism)
cmds = MyCLI.thunder[:commands]
puts cmds.keys.sort.map(&:to_s).join(",")

# The default command
puts MyCLI.thunder[:default_command]

# greet command attributes
greet = cmds[:greet]
puts greet[:usage]
puts greet[:description]

# add command has an option
add_cmd = cmds[:add]
puts add_cmd[:options].keys.map(&:to_s).join(",")
puts add_cmd[:options][:verbose][:type]
