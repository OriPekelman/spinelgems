require 'ruby_gpg'

# Smoke: test config defaults, command building, and output filename logic.
# All real logic without invoking GPG process.

# 1. Default config values
cfg = RubyGpg.config
puts cfg.executable    # => gpg
puts cfg.homedir       # => ~/.gnupg

# 2. gpg_command includes executable and key flags
cmd = RubyGpg.gpg_command
puts cmd.include?("gpg")            # => true
puts cmd.include?("--quiet")        # => true
puts cmd.include?("--no-tty")       # => true

# 3. Mutating config changes gpg_command
RubyGpg.config.executable = "/usr/local/bin/gpg2"
cmd2 = RubyGpg.gpg_command
puts cmd2.start_with?("/usr/local/bin/gpg2")  # => true

# Reset for next test
RubyGpg.config.executable = "gpg"

# 4. output_filename logic: armor=false => .gpg extension
#    We call the private method via send
opts_plain = { armor: false }
out_plain = RubyGpg.send(:output_filename, "/path/to/file", opts_plain)
puts out_plain   # => /path/to/file.gpg

opts_armor = { armor: true }
out_armor = RubyGpg.send(:output_filename, "/path/to/file", opts_armor)
puts out_armor   # => /path/to/file.asc

# 5. Custom output overrides extension
opts_custom = { armor: false, output: "/tmp/custom.out" }
out_custom = RubyGpg.send(:output_filename, "/path/to/file", opts_custom)
puts out_custom  # => /tmp/custom.out

# 6. Config homedir mutation
RubyGpg.config.homedir = "/custom/gnupg"
cmd3 = RubyGpg.gpg_command
puts cmd3.include?("/custom/gnupg")  # => true

# 7. Config is a Struct
puts RubyGpg::Config.ancestors.include?(Struct)  # => true
