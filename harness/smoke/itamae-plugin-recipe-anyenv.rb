# smoke: itamae-plugin-recipe-anyenv
# Tests the pure string-building logic in the top-level methods defined by the gem.
# The gem defines top-level methods (init, anyenv_init_with, etc.) for use inside
# itamae recipe DSL context; we exercise them without the DSL.

require 'itamae/plugin/recipe/anyenv'
# Version lives in a separate file; load it explicitly
require 'itamae/plugin/recipe/anyenv/version'

# 1. VERSION constant from the nested module
puts Itamae::Plugin::Recipe::Anyenv::VERSION

# 2. DEFAULT_ANYENV_ROOT constant
puts DEFAULT_ANYENV_ROOT

# 3. init sets @username and @root_path
init('deploy')
puts @username
puts @root_path

# 4. anyenv_init_with builds a shell command string with env vars prepended
cmd = anyenv_init_with('type rbenv')
# Check it contains expected substrings (printed for diff)
puts cmd.include?('export ANYENV_ROOT=/usr/local/anyenv')
puts cmd.include?('export PATH=/usr/local/anyenv/bin:${PATH}')
puts cmd.include?('eval "$(anyenv init -)"')
puts cmd.include?('type rbenv')

# 5. init with ANYENV_ROOT env override
orig = ENV['ANYENV_ROOT']
ENV['ANYENV_ROOT'] = '/opt/anyenv'
init('other')
puts @root_path
ENV['ANYENV_ROOT'] = orig

# 6. anyenv_init_with for install command
cmd2 = anyenv_init_with("yes | anyenv install rbenv")
puts cmd2.include?('yes | anyenv install rbenv')

# 7. Verify heredoc strip - the command is collapsed to one line (no literal newlines)
puts cmd2.include?("\n")
