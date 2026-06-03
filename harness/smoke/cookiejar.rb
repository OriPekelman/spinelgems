require 'cookiejar'

# 1. Parse a simple Netscape-style cookie from a Set-Cookie header
cookie = CookieJar::Cookie.from_set_cookie(
  'http://www.example.com/path/to/page',
  'session_id=abc123; path=/; domain=example.com'
)
puts cookie.name
puts cookie.value
puts cookie.domain
puts cookie.path
puts cookie.secure.inspect
puts cookie.session?.inspect

# 2. Parse a secure, HttpOnly cookie with a fixed expiry
cookie2 = CookieJar::Cookie.from_set_cookie(
  'https://secure.example.com/',
  'auth=xyz789; path=/; domain=secure.example.com; secure; HttpOnly; expires=Thu, 01 Jan 2099 00:00:00 GMT'
)
puts cookie2.name
puts cookie2.value
puts cookie2.secure.inspect
puts cookie2.http_only.inspect
puts cookie2.expired?.inspect

# 3. Use the Jar: set cookies and retrieve them for matching URIs
jar = CookieJar::Jar.new
jar.set_cookie('http://www.example.com/', 'foo=bar; path=/')
jar.set_cookie('http://www.example.com/app', 'baz=qux; path=/app')

cookies_root = jar.get_cookies('http://www.example.com/')
puts cookies_root.map(&:name).sort.inspect

cookies_app = jar.get_cookies('http://www.example.com/app/page')
# /app path cookie should appear as well as root cookie
puts cookies_app.map(&:name).sort.inspect

# 4. get_cookie_header returns a semicolon-joined Netscape-style string
header = jar.get_cookie_header('http://www.example.com/')
puts header.include?('foo=bar').inspect

# 5. Cookie#to_s basic roundtrip
puts cookie.to_s
