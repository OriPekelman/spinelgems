# frozen_string_literal: true

require 'unifacop'

# Test VERSION constant
puts UniFaCop::VERSION

# Test CONFIG_FILE_NAME constant
puts UniFaCop::CLI::CONFIG_FILE_NAME

# Test retrieve_command_name with a regular command arg (shifts it off)
args1 = ['init', '--flag']
cmd = UniFaCop::CLI.retrieve_command_name(args1)
puts cmd
puts args1.inspect

# Test retrieve_command_name with a flag-only arg (no shift)
args2 = ['--help']
cmd2 = UniFaCop::CLI.retrieve_command_name(args2)
puts cmd2.nil? ? 'nil' : cmd2
puts args2.inspect

# Test retrieve_command_name with empty args
args3 = []
cmd3 = UniFaCop::CLI.retrieve_command_name(args3)
puts cmd3.nil? ? 'nil' : cmd3
