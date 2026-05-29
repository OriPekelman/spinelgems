puts HrefProtocol::Sanitizer.new("example.com").href
puts HrefProtocol::Sanitizer.new("http://example.com").href
puts HrefProtocol::Sanitizer.new("https://example.com/path").href
puts HrefProtocol::Sanitizer.new("ftp://files.example.com").href
puts HrefProtocol::Sanitizer.new("mailto:user@example.com").href
puts HrefProtocol::Sanitizer.new("/relative/path").href
puts HrefProtocol::Sanitizer.new("  spaced.com  ").href
puts HrefProtocol::Sanitizer.new("").href.inspect
