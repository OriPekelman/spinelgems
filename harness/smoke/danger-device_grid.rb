# Smoke test for danger-device_grid 0.2.0
# The plugin.rb top-level requires 'fastlane' (external gem) and inherits from
# Danger::Plugin. We cannot load the class under Spinel (no load-path for
# external gems). Instead we exercise the two pure-Ruby helper methods
# (beautiful_device_name / url_for_device) inlined here — same logic,
# no external deps. We also load the gem's own VERSION constant.

# Load only the version file, which has no external deps.
require 'danger_device_grid'

puts "version=#{DeviceGrid::VERSION}"

# Replicate the plugin's pure helper logic (no Danger/Fastlane needed).
module DeviceGridSmoke
  FASTLANE_VERSION = "2.0.0"

  def self.beautiful_device_name(str)
    {
      iphone4s:    "iPhone 4s",
      iphone5s:    "iPhone 5s",
      iphone6s:    "iPhone 6s",
      iphone6splus: "iPhone 6s Plus",
      ipadair:     "iPad Air",
      iphone6:     "iPhone 6",
      iphone7:     "iPhone 7",
      iphone6plus: "iPhone 6 Plus",
      iphone7plus: "iPhone 7 Plus",
      ipadair2:    "iPad Air 2",
      nexus5:      "Nexus 5",
      nexus7:      "Nexus 7",
      nexus9:      "Nexus 9"
    }[str.to_sym] || str.to_s
  end

  def self.url_for_device(str)
    str = str.to_sym
    host = "https://raw.githubusercontent.com/fastlane/fastlane/#{FASTLANE_VERSION}/fastlane/lib/fastlane/actions/device_grid/assets/"
    {
      iphone4s:    host + "iphone4s.png",
      iphone5s:    host + "iphone5s.png",
      iphone6:     host + "iphone6s.png",
      iphone7:     host + "iphone6s.png",
      iphone6s:    host + "iphone6s.png",
      iphone6plus: host + "iphone6splus.png",
      iphone7plus: host + "iphone6splus.png",
      iphone6splus: host + "iphone6splus.png",
      ipadair:     host + "ipadair.png",
      ipadair2:    host + "ipadair.png"
    }[str] || ""
  end
end

puts "=== beautiful_device_name ==="
%w[iphone4s iphone5s iphone6s iphone6splus ipadair iphone6
   iphone7 iphone6plus iphone7plus ipadair2 nexus5 nexus7 nexus9].each do |d|
  puts "#{d} => #{DeviceGridSmoke.beautiful_device_name(d)}"
end
puts "unknown_device => #{DeviceGridSmoke.beautiful_device_name('unknown_device')}"

puts "=== url_for_device ==="
%w[iphone4s iphone5s iphone6 iphone6s iphone7 iphone6plus iphone6splus iphone7plus ipadair ipadair2].each do |d|
  url = DeviceGridSmoke.url_for_device(d)
  puts "#{d} => #{url.split('/').last}"
end
puts "unknowndevice => '#{DeviceGridSmoke.url_for_device('unknowndevice')}'"
