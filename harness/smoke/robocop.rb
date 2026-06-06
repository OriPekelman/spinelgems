require 'robocop'

# Test 1: VALID_DIRECTIVES constant
puts "VALID_DIRECTIVES count: #{Robocop::Middleware::VALID_DIRECTIVES.length}"
puts "Has noindex: #{Robocop::Middleware::VALID_DIRECTIVES.include?('noindex')}"
puts "Has nofollow: #{Robocop::Middleware::VALID_DIRECTIVES.include?('nofollow')}"

# Test 2: ignore? when no options given
fake_app = ->(env) { [200, {}, []] }
mw_default = Robocop::Middleware.new(fake_app)
puts "ignore? with no options: #{mw_default.ignore?}"

# Test 3: valid_directives filters invalid entries
mw_directives = Robocop::Middleware.new(fake_app, directives: %w[noindex nofollow dogs cats])
puts "ignore? with directives: #{mw_directives.ignore?}"
result = mw_directives.valid_directives(%w[noindex nofollow dogs cats])
puts "valid_directives filtered: #{result.sort.join(', ')}"

# Test 4: add_robots_tag_header! with plain directives
headers = {}
mw_directives2 = Robocop::Middleware.new(fake_app, directives: %w[noindex noarchive])
mw_directives2.add_robots_tag_header!(headers)
puts "X-Robots-Tag (directives): #{headers['X-Robots-Tag']}"

# Test 5: add_robots_tag_header! with useragents
headers2 = {}
mw_ua = Robocop::Middleware.new(fake_app, useragents: { googlebot: %w[noindex nofollow], bingbot: %w[nosnippet] })
mw_ua.add_robots_tag_header!(headers2)
tag = headers2['X-Robots-Tag']
puts "X-Robots-Tag lines: #{tag.split("\n").length}"
puts "Contains googlebot: #{tag.include?('googlebot')}"
puts "Contains bingbot: #{tag.include?('bingbot')}"
