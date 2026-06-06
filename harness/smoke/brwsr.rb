require 'brwsr'

# Chrome on Linux
chrome_ua = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
b = Brwsr::Browser.new(ua: chrome_ua, accept_language: "en-us, fr;q=0.9")
puts b.id.inspect           # :chrome
puts b.name                 # Chrome
puts b.version              # 114
puts b.chrome?              # true
puts b.webkit?              # true
puts b.safari?              # false
puts b.firefox?             # false
puts b.platform.inspect     # :linux
puts b.mobile?              # false
puts b.capable?             # true
puts b.accept_language.inspect  # ["en-us", "fr"]

# Firefox on Windows
ff_ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0"
b2 = Brwsr::Browser.new(ua: ff_ua, accept_language: "de")
puts b2.id.inspect          # :firefox
puts b2.name                # Firefox
puts b2.version             # 115
puts b2.firefox?            # true
puts b2.windows?            # true
puts b2.platform.inspect    # :windows
puts b2.to_s                # meta string

# iPhone Safari
iphone_ua = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1"
b3 = Brwsr::Browser.new(ua: iphone_ua)
puts b3.id.inspect          # :iphone
puts b3.iphone?             # true
puts b3.ios?                # true
puts b3.mobile?             # true
puts b3.webkit?             # true
puts b3.platform.inspect    # :other (no Windows/Linux/Mac OS X in this UA)
puts b3.version             # 16
puts b3.to_s                # meta string

# Android mobile
android_ua = "Mozilla/5.0 (Linux; Android 12; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.5615.135 Mobile Safari/537.36"
b4 = Brwsr::Browser.new(ua: android_ua)
puts b4.id.inspect          # :chrome (Chrome UA wins over android? when chrome? is checked first)
puts b4.android?            # false (because chrome? check is first in id, android? = android && !opera? which is true, but id returns :chrome)
puts b4.mobile?             # true
puts b4.linux?              # true
