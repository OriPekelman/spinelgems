# Smoke test for chef-deployment-monitor
# Tests core parsing logic: scan, extract_query_string, format, digest
# Config and Logmon.run require external deps (mixlib/config, file-tail) — not tested

require 'date'
require 'digest'
require 'json'

# Stub out the external dep so require in config.rb is harmless
module Mixlib
  module Config
    def self.extended(base); end
    def self.included(base); end
    def config_strict_mode(_val); end
    def default(key, val = nil, &blk); end
    def configurable(_key); end
    def [](key); nil; end
  end
end

# Provide a no-op LOGMONNAME constant used in scan
LOGMONNAME = 'testserver' unless defined?(LOGMONNAME)

require 'chef_deployment_monitor/log'
require 'chef_deployment_monitor/sinks'
require 'chef_deployment_monitor/logmon'

# Instantiate the Logmon class (skips run which needs file-tail)
logmon = Chef::Deployment::Monitor::Logmon.new

# --- extract_query_string ---
url1 = '/organizations/myorg/cookbooks/nginx/1.0.0?head=1&tail=0'
qs = logmon.extract_query_string(url1)
puts "query_string keys: #{qs.keys.sort.join(',')}"
puts "head=#{qs['head']} tail=#{qs['tail']}"

url_no_qs = '/organizations/myorg/cookbooks/nginx'
puts "no_qs: #{logmon.extract_query_string(url_no_qs).inspect}"

# --- scan ---
# Build a synthetic Chef server log line matching the regex
# Format: IP - - [DD/Mon/YYYY:HH:MM:SS +ZZZZ]  "METHOD /path HTTP/1.1" STATUS "..." SIZE "-" "..." x13 more quoted fields
fields = [
  '10.0.0.1',                                          # 1 IP
  '',                                                   # 2 ident (empty)
  '01/Jan/2024:12:00:00 +0000',                         # 3 time
  'PUT',                                                # 4 action
  '/organizations/acmecorp/cookbooks/myapp/2.3.1',      # 5 URL
  'HTTP/1.1',                                           # 6 proto
  '200',                                                # 7 status
  '-',                                                  # 8 body size (quoted)
  '42',                                                 # 9 something (quoted? no, unquoted in regex)
  '-',                                                  # 10
  'Mozilla/5.0',                                        # 11
  'req-abc123',                                         # 12
  '10.0.0.2',                                           # 13
  'chef-client/14.0',                                   # 14
  '1.2.3',                                              # 15
  'bob',                                                # 16 user
  'x-request-id-1',                                    # 17
  'x-forwarded-for',                                   # 18
  'x-somewhere',                                        # 19
]
# Reconstruct line exactly as regex expects:
# IP - (empty)- [time]  "METHOD URL proto" status "body_size" size "-" "f10" "f11" "f12" "f13" "f14" "f15" "f16" "f17" "f18" "f19"
line = "#{fields[0]} - #{fields[1]}- [#{fields[2]}]  \"#{fields[3]} #{fields[4]} #{fields[5]}\" #{fields[6]} \"#{fields[7]}\" #{fields[8]} \"-\" \"#{fields[9]}\" \"#{fields[10]}\" \"#{fields[11]}\" \"#{fields[12]}\" \"#{fields[13]}\" \"#{fields[14]}\" \"#{fields[15]}\" \"#{fields[16]}\" \"#{fields[17]}\" \"#{fields[18]}\""

data = logmon.scan(line)
if data
  puts "scan org: #{data['org']}"
  puts "scan object: #{data['object']}"
  puts "scan name: #{data['name']}"
  puts "scan version: #{data['version']}"
  puts "scan action: #{data['action']}"
  puts "scan user: #{data['user']}"
else
  puts "scan: nil (no match)"
end

# --- format ---
if data
  formatted = logmon.format(data)
  puts "format time is Integer: #{formatted['time'].is_a?(Integer)}"
  puts "format server: #{formatted['server']}"
end

# --- digest ---
if data
  digested = logmon.digest(data)
  puts "digest key present: #{digested.key?('digest')}"
  puts "digest length: #{digested['digest'].length}"
  # Verify digest is deterministic
  d2 = logmon.digest(data)
  puts "digest deterministic: #{digested['digest'] == d2['digest']}"
end

# --- scan with forbidden (403) returns nil ---
line403 = line.sub(/ 200 /, ' 403 ')
puts "scan 403: #{logmon.scan(line403).inspect}"

# --- scan with non-matching line returns nil ---
puts "scan_bad: #{logmon.scan('not a chef log line').inspect}"
