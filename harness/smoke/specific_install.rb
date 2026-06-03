require 'specific_install'
require 'specific_install/version'
require 'rubygems/commands/specific_install_command'
require 'stringio'

# VERSION constant (from specific_install/version)
puts SpecificInstall::VERSION

cmd = Gem::Commands::SpecificInstallCommand.new(StringIO.new)

# description: pure string method
puts cmd.description

# usage: pure string method
puts cmd.usage

# arguments: multi-line — print first line trimmed
puts cmd.arguments.lines.first.strip

# gem_name (private): derived from @loc by splitting on "/"
cmd.instance_variable_set(:@loc, "https://github.com/rdp/specific_install.git")
puts cmd.send(:gem_name)

# valid_subdir? (private): pure regex path validation
# On Linux, File::PATH_SEPARATOR = ":", File::SEPARATOR = "/"
# ABS_REGEX = /\A:/ which does NOT match "/" on Linux — so "/absolute" passes as valid
puts cmd.send(:valid_subdir?, "src/ruby")       # true  — normal relative path
puts cmd.send(:valid_subdir?, "../escape")       # false — dotdot blocked
puts cmd.send(:valid_subdir?, "")               # false — empty string blocked
puts cmd.send(:valid_subdir?, "deep/nested/ok") # true  — nested relative path

# GitInstallCommand is a subclass alias
puts Gem::Commands::GitInstallCommand.superclass == Gem::Commands::SpecificInstallCommand
