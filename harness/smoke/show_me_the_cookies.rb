require 'show_me_the_cookies'

# --- adapter registry ---
# Verify built-in adapters are registered
keys = ShowMeTheCookies.adapters.keys.map(&:to_s).sort
puts keys.join(',')
# => rack_test,selenium,selenium_chrome,selenium_chrome_headless,selenium_headless

puts ShowMeTheCookies.adapters[:rack_test].name
# => ShowMeTheCookies::RackTest

# --- register_adapter ---
class MyTestAdapter; end
ShowMeTheCookies.register_adapter(:my_driver, MyTestAdapter)
puts ShowMeTheCookies.adapters[:my_driver].name
# => MyTestAdapter
puts ShowMeTheCookies.adapters.keys.length
# => 6

# --- RackTest#_translate_cookie via mock cookie ---
NormalCookie = Struct.new(:name, :domain, :value, :expires, :path) do
  def secure?; false; end
  def expired?; false; end
  def instance_variable_get(var)
    var == :@options ? {} : nil
  end
end

adapter = ShowMeTheCookies::RackTest.allocate
c = NormalCookie.new('session_id', 'example.com', 'abc123', nil, '/')
t = adapter.send(:_translate_cookie, c)
puts t[:name]
# => session_id
puts t[:domain]
# => example.com
puts t[:value]
# => abc123
puts t[:path]
# => /
puts t[:secure]
# => false
puts t[:httponly]
# => false

# --- httponly flag detection ---
HttpOnlyCookie = Struct.new(:name, :domain, :value, :expires, :path) do
  def secure?; true; end
  def expired?; false; end
  def instance_variable_get(var)
    var == :@options ? {'HttpOnly' => true} : nil
  end
end

c2 = HttpOnlyCookie.new('auth_token', 'secure.example.com', 'tok123', nil, '/app')
t2 = adapter.send(:_translate_cookie, c2)
puts t2[:name]
# => auth_token
puts t2[:secure]
# => true
puts t2[:httponly]
# => true

# --- delete_cookie logic via mock cookies array ---
CookieA = Struct.new(:name) do
  def expired?; false; end
end

# Simulate the cookies array and call delete_cookie logic inline
# (mirrors RackTest#delete_cookie: cookies.reject! { |c| c.name.downcase == name.to_s })
cookies = [CookieA.new('session'), CookieA.new('tracking'), CookieA.new('prefs')]
cookies.reject! { |c| c.name.downcase == 'tracking' }
puts cookies.map(&:name).join(',')
# => session,prefs

# --- get_me_the_cookies mapping ---
cookies2 = [
  NormalCookie.new('a', 'x.com', 'v1', nil, '/'),
  NormalCookie.new('b', 'x.com', 'v2', nil, '/sub')
]
mapped = cookies2.map { |c| adapter.send(:_translate_cookie, c) }
puts mapped.map { |h| h[:name] }.join(',')
# => a,b
puts mapped.map { |h| h[:value] }.join(',')
# => v1,v2
