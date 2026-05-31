puts Urlmatch.urlmatch("https://example.com/*", "https://example.com/foo")
puts Urlmatch.urlmatch("https://example.com/*", "https://other.com/foo")
puts Urlmatch.urlmatch("*://example.com/*", "http://example.com/bar")
puts Urlmatch.urlmatch("http://*.example.com/*", "http://sub.example.com/baz")
puts Urlmatch.urlmatch("http://*.example.com/*", "http://example.com/baz")
puts Urlmatch.urlmatch("https://*/path", "https://anything.net/path")

begin
  Urlmatch.urlmatch("bad-pattern", "https://example.com/")
rescue Urlmatch::Error => e
  puts e.message
end
