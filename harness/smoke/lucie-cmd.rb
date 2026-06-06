require 'lucie-cmd'

# Lucie::Commands is a mixin for command-line helpers.
# Exercise via a concrete class that includes it.
class Runner
  include Lucie::Commands

  def run_tests
    # 1. colorize: pure string logic, no subprocess
    red_str   = colorize("hello", 31)
    green_str = colorize("world", 32)
    puts red_str
    puts green_str

    # 2. sh with echo — captures stdout into output
    sh "echo spinel"
    puts output.chomp

    # 3. sh return value: true on success, false on failure
    ok  = sh("true")
    bad = sh("false")
    puts ok.inspect
    puts bad.inspect

    # 4. set :show_command makes sh print "$ cmd" to stdout
    set :show_command
    sh "echo shown"
    unset :show_command
    sh "echo quiet"
    puts output.chomp   # only last command output captured
  end
end

Runner.new.run_tests
