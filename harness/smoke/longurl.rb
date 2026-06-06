require 'longurl'

# 1. Exception hierarchy: all custom exceptions inherit from StandardError
puts LongURL::InvalidURL.ancestors.include?(StandardError)          # true
puts LongURL::UnsupportedService.ancestors.include?(StandardError)  # true
puts LongURL::TooManyRedirections.ancestors.include?(StandardError) # true
puts LongURL::NetworkError.ancestors.include?(StandardError)        # true
puts LongURL::UnknownError.ancestors.include?(StandardError)        # true

# 2. LongURL::URL.check raises InvalidURL for nil/empty/non-http inputs
[nil, '', 'not-a-url', 'ftp://example.com'].each do |bad|
  begin
    LongURL::URL.check(bad)
    puts "no-raise:#{bad.inspect}"
  rescue LongURL::InvalidURL
    puts "InvalidURL:#{bad.inspect}"
  end
end

# 3. LongURL::URL.check returns a URI::HTTP for valid http URLs
result = LongURL::URL.check('http://example.com/path')
puts result.class       # URI::HTTP
puts result.host        # example.com
puts result.path        # /path

# 4. ShortURLMatchRegexp matches http short URLs in text
text = "check out http://bit.ly/abc123 and http://t.co/xyz also plain text"
matches = text.scan(LongURL::ShortURLMatchRegexp)
puts matches.length     # 2
puts matches[0]         # http://bit.ly/abc123
puts matches[1]         # http://t.co/xyz
