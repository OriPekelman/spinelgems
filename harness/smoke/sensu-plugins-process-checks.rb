# smoke: sensu-plugins-process-checks
# Exercises the version module and the pure-Ruby helper logic from check-process.rb
# without requiring the external sensu-plugin gem.

require 'sensu-plugins-process-checks'

# 1. Version constants
puts SensuPluginsProcessChecks::Version::MAJOR
puts SensuPluginsProcessChecks::Version::MINOR
puts SensuPluginsProcessChecks::Version::PATCH
puts SensuPluginsProcessChecks::Version::VER_STRING

# 2. Inline the pure helpers from check-process.rb (no sensu-plugin needed).
#    line_to_hash: zip column names onto whitespace-split fields.
def line_to_hash(line, *cols)
  Hash[cols.zip(line.strip.split(/\s+/, cols.size))]
end

#    etime_to_esec: parse ps etime strings (DD-HH:MM:SS) to integer seconds.
def etime_to_esec(etime)
  m = /(\d+-)?(\d\d:)?(\d\d):(\d\d)/.match(etime)
  (m[1] || 0).to_i * 86_400 + (m[2] || 0).to_i * 3600 + (m[3] || 0).to_i * 60 + (m[4] || 0).to_i
end

# 3. Exercise line_to_hash with a realistic ps output line.
ps_line = "root  1234  204800  51200  0.5  4  S  1-02:30:15  00:00:42  /sbin/init"
h = line_to_hash(ps_line, :user, :pid, :vsz, :rss, :cpu, :thcount, :state, :etime, :time, :command)
puts h[:user]
puts h[:pid]
puts h[:vsz]
puts h[:state]
puts h[:command]

# 4. Exercise etime_to_esec with varied formats.
# "02:30" => 2*60 + 30 = 150
puts etime_to_esec("02:30")
# "01:02:30" => 3600 + 150 = 3750
puts etime_to_esec("01:02:30")
# "1-02:30:15" => 86400 + 3600*2 + 30*60 + 15 = 86400 + 7200 + 1800 + 15 = 95415
puts etime_to_esec("1-02:30:15")
# "00:05" => 5
puts etime_to_esec("00:05")
