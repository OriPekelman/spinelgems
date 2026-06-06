# frozen_string_literal: true

require 'fablicop'

# Fablicop is a RuboCop configuration distribution gem with a thin CLI.
# Smoke tests: VERSION constant, CLI arg parsing, and help text output.

# 1. Version constant
puts Fablicop::VERSION

# 2. CLI.retrieve_command_name — extracts first non-flag arg and mutates args
args1 = ['init', '--extra']
cmd1 = Fablicop::CLI.retrieve_command_name(args1)
puts cmd1.inspect
puts args1.inspect  # args1 should have 'init' shifted out

# 3. retrieve_command_name with a flag-first arg (should return nil, no shift)
args2 = ['--help']
cmd2 = Fablicop::CLI.retrieve_command_name(args2)
puts cmd2.inspect
puts args2.inspect  # args2 unchanged

# 4. retrieve_command_name with empty args
args3 = []
cmd3 = Fablicop::CLI.retrieve_command_name(args3)
puts cmd3.inspect

# 5. print_help (writes to stdout)
Fablicop::CLI.print_help
