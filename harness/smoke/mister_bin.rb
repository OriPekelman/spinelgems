# Smoke: mister_bin 0.9.0
# Exercises CommandMeta DSL (docopt string building), Command class-level DSL,
# Runner routing, and find_target_command dispatch.
# colsole and docopt_ng are runtime deps not present in lib/ — stub them so
# the core mister_bin DSL logic runs standalone.

$LOADED_FEATURES << 'colsole'
$LOADED_FEATURES << 'docopt_ng'

module Colsole
  def self.included(base); end
  def word_wrap(text, *_args); text; end
  def say(text); end
end

module DocoptNG; end

require 'mister_bin'
require 'mister_bin/command_meta'
require 'mister_bin/command'
require 'mister_bin/runner'

# --- 1. CommandMeta: DSL building and docopt string generation ---
meta = MisterBin::CommandMeta.new
meta.summary = 'A test command'
meta.help = 'Does something useful with files'
meta.version = '1.2.3'
meta.usages << 'test_cmd [options] <file>'
meta.options << ['--verbose -v', 'Enable verbose output']
meta.commands << ['run', 'Run the thing']
meta.params << ['FILE', 'The input file']
meta.examples << 'test_cmd --verbose myfile.txt'

puts meta.description
puts meta.version
puts meta.long_description.lines.count

doc = meta.docopt
puts doc.include?('Usage:')
puts doc.include?('Options:')
puts doc.include?('Commands:')
puts doc.include?('Parameters:')
puts doc.include?('Examples:')
puts doc.include?('--version')

# --- 2. Command DSL: class-level meta accessors ---
class GreetCmd < MisterBin::Command
  summary 'Greet the user'
  help 'Prints a greeting to stdout'
  version '2.0.0'
  usage 'greet [--name NAME]'
  option '--name NAME', 'Name to greet'
  param '<name>', 'The name parameter'
  example 'greet --name Alice'
end

puts GreetCmd.meta.summary
puts GreetCmd.meta.version
puts GreetCmd.meta.description
puts GreetCmd.docopt.include?('Greet the user')
puts GreetCmd.docopt.include?('--name NAME')

# --- 3. Command DSL: target_commands registration ---
class MathCmd < MisterBin::Command
  summary 'Math operations'
  usage 'math add <a> <b>'
  usage 'math mul <a> <b>'
  command 'add', 'Add two numbers'
  command 'mul', 'Multiply two numbers'

  def add_command
    a = args['<a>'].to_i
    b = args['<b>'].to_i
    puts "#{a} + #{b} = #{a + b}"
    0
  end

  def mul_command
    a = args['<a>'].to_i
    b = args['<b>'].to_i
    puts "#{a} * #{b} = #{a * b}"
    0
  end
end

puts MathCmd.meta.summary
puts MathCmd.target_commands.inspect

# --- 4. find_target_command: dispatch lookup ---
puts MathCmd.find_target_command(MathCmd.new, {'add' => true, 'mul' => false}).inspect
puts MathCmd.find_target_command(MathCmd.new, {'add' => false, 'mul' => true}).inspect
puts MathCmd.find_target_command(MathCmd.new, {'add' => false, 'mul' => false}).inspect

# --- 5. Runner: routing and metadata inspection ---
class EchoCmd < MisterBin::Command
  summary 'Echo a message'
  usage 'echo <message>'
  param '<message>', 'The message to echo'
end

class StatusCmd < MisterBin::Command
  summary 'Show status'
  usage 'status'
end

runner = MisterBin::Runner.new(header: 'TestApp v3.0', version: '3.0.0')
runner.route 'echo', to: EchoCmd
runner.route 'status', to: StatusCmd

puts runner.header
puts runner.version
puts runner.commands.keys.sort.inspect
puts runner.commands['echo'].meta.description
puts runner.commands['status'].meta.description
puts runner.aliases.inspect

# --- 6. CommandMeta#description / long_description edge cases ---
meta2 = MisterBin::CommandMeta.new
meta2.help = 'Only help, no summary'
puts meta2.description
puts meta2.long_description

meta3 = MisterBin::CommandMeta.new
puts meta3.description.empty?

# --- 7. Command DSL with environment vars ---
class EnvCmd < MisterBin::Command
  summary 'Env test'
  usage 'cmd [options]'
  environment 'DATABASE_URL', 'The database URL'
  environment 'API_TOKEN', 'Authentication token'
end

doc4 = EnvCmd.docopt
puts doc4.include?('Environment Variables:')
puts doc4.include?('DATABASE_URL')
puts doc4.include?('API_TOKEN')
