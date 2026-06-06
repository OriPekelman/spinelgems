require 'normalize_url'

# NormalizeUrl.process normalizes absolute HTTP/HTTPS URLs:
# - removes trailing slash
# - removes URL fragment (#anchor)
# - removes repeating slashes
# - strips tracking query params (utm_*, etc.) when :remove_tracking is set

puts NormalizeUrl.process('http://example.com/path/')
puts NormalizeUrl.process('https://example.com/page#section')
puts NormalizeUrl.process('http://example.com//double//slashes/')
puts NormalizeUrl.process('http://example.com/path/?utm_source=newsletter&utm_medium=email&q=ruby',
                          remove_tracking: true)
puts NormalizeUrl.process('http://example.com/path/?b=2&a=1', sort_query: true)
puts NormalizeUrl.process('http://example.com/path/?foo=keep&bar=drop',
                          remove_params: [:bar])

begin
  NormalizeUrl.process('not-a-url')
rescue NormalizeUrl::InvalidURIError => e
  puts "InvalidURIError: #{e.message}"
end

begin
  NormalizeUrl.process('ftp://example.com/file')
rescue NormalizeUrl::InvalidURIError => e
  puts "InvalidURIError: #{e.message}"
end
