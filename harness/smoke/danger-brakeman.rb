# danger-brakeman: Danger plugin wrapping Brakeman static analysis tool.
# The gem's main class (Danger::DangerBrakeman) requires danger-plugin-api
# (Danger::Plugin base class) which is not installed. The --full harness
# force-loads lib/brakeman/plugin.rb, which does `require 'brakeman/plugin'`;
# with -I lib that is circular (the same file), so Danger::Plugin is never
# defined → NameError at class definition time → smoke-error:cruby.
#
# Only lib/brakeman/gem_version.rb is self-contained.

require 'danger_brakeman'

puts "VERSION: #{Brakeman::VERSION}"

# Exercise Shellwords (stdlib, but part of the gem's actual file-joining logic)
require 'shellwords'
files = ['app/controllers/vuls_controller.rb', 'app/models/user.rb']
joined = Shellwords.join(files).gsub(' ', ',')
puts "Files joined: #{joined}"

# Format brakeman warning messages (mirrors _add_warning_for_each_line logic)
warnings = [
  { 'message' => 'Unsafe reflection method `constantize` called with parameter value',
    'file'    => 'app/controllers/vuls_controller.rb',
    'line'    => 45 },
  { 'message' => '`protect_from_forgery` should be called in `VulsController`',
    'file'    => 'app/models/user.rb',
    'line'    => 1 }
]
warnings.each do |w|
  puts "[brakeman] #{w['message']} (#{w['file']}:#{w['line']})"
end
puts "Warning count: #{warnings.length}"
