# Smoke: nginx-watcher 0.0.1
#
# nginx-watcher is a skeleton gem: lib/nginx-watcher.rb immediately requires
# 'eventmachine', 'eventmachine-tail', and 'em-http' at the top level.
# None of these are available in the isolated smoke environment.
#
# Under Spinel, plain `require` to external gems is silently ignored, so the
# two regex constants (IP, LOCALTIME) get defined. Under CRuby, the file
# fails at line 1 with LoadError before any constants are defined.
#
# The only loadable surface without eventmachine is nginx-watcher/version.

require 'nginx-watcher/version'

puts "Nginx::Watcher::VERSION=#{Nginx::Watcher::VERSION}"

# Reproduce the IP + LOCALTIME constants (copied verbatim from lib/nginx-watcher.rb)
# so we can exercise the regex logic even without eventmachine.
ip_re = /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s/
localtime_re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\s-\s.*\s\[(.*)\]/

log_lines = [
  "192.168.1.1 - frank [10/Oct/2000:13:55:36 -0700] \"GET /index.html HTTP/1.0\" 200 1234",
  "10.0.0.42 - - [01/Jan/2024:00:00:01 +0000] \"POST /api HTTP/1.1\" 201 88",
  "not-an-ip line without valid address",
  "172.16.254.1 - admin [25/Dec/2023:12:00:00 +0530] \"GET / HTTP/1.1\" 301 0",
]

log_lines.each do |line|
  ip  = (m = ip_re.match(line))        ? m[1] : "(none)"
  ts  = (m = localtime_re.match(line)) ? m[1] : "(none)"
  puts "ip=#{ip} ts=#{ts}"
end
