# frozen_string_literal: true

require 'device_wizard'

detector = DeviceWizard::UserAgentDetector.new

# Test 1: get_device_type with various user agents
mobile_ua = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 Mobile/15E148"
desktop_ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/91.0.4472.124 Safari/537.36"
tablet_ua = "Mozilla/5.0 (iPad; CPU OS 14_0 like Mac OS X) AppleWebKit/605.1.15 tablet Safari/604.1"
crawler_ua = "Googlebot/2.1 (+http://www.google.com/bot.html)"
android_ua = "Mozilla/5.0 (Linux; Android 10; SM-A505F) AppleWebKit/537.36 Chrome/91.0"

puts detector.get_device_type(mobile_ua.dup)
puts detector.get_device_type(desktop_ua.dup)
puts detector.get_device_type(tablet_ua.dup)
puts detector.get_device_type(crawler_ua.dup)
puts detector.get_device_type(android_ua.dup)
puts detector.get_device_type("")

# Test 2: get_browser
firefox_ua = "Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0"
chrome_ua = "Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"

b1 = detector.get_browser(firefox_ua.dup)
puts "#{b1.name}/#{b1.version}"

b2 = detector.get_browser(chrome_ua.dup)
puts "#{b2.name}/#{b2.version}"

# Test 3: get_os
android_os_ua = "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36"
ios_ua = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)"
windows_ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

o1 = detector.get_os(android_os_ua.dup)
puts o1.name

o2 = detector.get_os(ios_ua.dup)
puts o2.name

o3 = detector.get_os(windows_ua.dup)
puts o3.name

# Test 4: get_details returns full device info
d = detector.get_details(firefox_ua.dup)
puts d.type
puts d.browser.name
