require 'url_regex'

# Test 1: validation regex class
rx_validate = UrlRegex.get(scheme_required: true, mode: :validation)
puts rx_validate.class

# Test 2: valid URLs match
valid_urls = [
  'https://www.example.com',
  'http://example.com/path?q=1#frag',
  'ftp://files.example.org/pub/file.txt',
]
valid_urls.each do |url|
  puts "valid #{url}: #{!!(url =~ rx_validate)}"
end

# Test 3: invalid URLs do not match
invalid_urls = [
  'not-a-url',
  'http://192.168.1.1/private',
  'http://10.0.0.1/local',
]
invalid_urls.each do |url|
  puts "invalid #{url}: #{!!(url =~ rx_validate)}"
end

# Test 4: scheme optional allows bare hostname
rx_no_scheme = UrlRegex.get(scheme_required: false, mode: :validation)
puts "no-scheme example.com: #{!!('example.com' =~ rx_no_scheme)}"

# Test 5: parsing mode extracts URLs from text
rx_parse = UrlRegex.get(scheme_required: true, mode: :parsing)
text = "Visit https://ruby-lang.org or http://github.com for info."
matches = text.scan(rx_parse)
puts "parsed count: #{matches.length}"
matches.each { |m| puts "parsed: #{m}" }

# Test 6: wrong mode raises ArgumentError
begin
  UrlRegex.get(mode: :invalid_mode)
  puts "no error raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end
