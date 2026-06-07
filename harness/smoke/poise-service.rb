require 'poise_service'

# VERSION
puts PoiseService::VERSION

# Error class hierarchy
begin
  raise PoiseService::Error, 'boom'
rescue PoiseService::Error => e
  puts "caught PoiseService::Error: #{e.message}"
  puts "is_a?(Exception): #{e.is_a?(Exception)}"
end

# Utils.parse_service_name: skips common segments (var/www/current/etc)
paths = [
  '/var/www/myapp/current',
  '/srv/apps/rails-app',
  '/home/deploy/myapp/current',
  '/etc/nginx',
  '/var/current',
]
paths.each do |path|
  puts "#{path} => #{PoiseService::Utils.parse_service_name(path)}"
end

# COMMON_SEGMENTS constant is a Hash of ignored path segments
puts PoiseService::Utils::COMMON_SEGMENTS.keys.sort.inspect
