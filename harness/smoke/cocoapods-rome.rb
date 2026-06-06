# Smoke test for cocoapods-rome 1.0.1
# This gem is a CocoaPods plugin that builds iOS/tvOS/watchOS frameworks.
# Core logic: PLATFORMS constant and xcodebuild arg-building.
# We stub Pod::HooksManager so we can load without the cocoapods gem.

# Stub the Pod module hierarchy that post_install.rb requires at load time
module Pod
  module HooksManager
    def self.register(name, hook_type, &block)
      # no-op: plugin hooks not exercised in isolation
    end
  end
end

require 'cocoapods-rome'

# 1. Version constant
puts "version: #{CocoapodsRome::VERSION}"

# 2. Load post_install where PLATFORMS and the helper functions live.
#    fourflusher is a runtime dep; pre-stub the require so it doesn't fail.
module Fourflusher
  class SimControl
    def destination(filter, os = :ios, minimum_version = '1.0')
      ['-destination', "id=FAKE-SIM-#{os}-#{minimum_version}"]
    end
  end
end

# Patch require so `require 'fourflusher'` inside post_install is a no-op
# (our module stub above already defines what's needed)
module Kernel
  alias_method :_orig_require_cocoapodsrome, :require
  def require(path)
    return true if path == 'fourflusher'
    _orig_require_cocoapodsrome(path)
  end
end

require 'cocoapods-rome/post_install'

# 3. PLATFORMS constant — maps simulator SDK names to human platform names
puts "PLATFORMS count: #{PLATFORMS.size}"
['iphonesimulator', 'appletvsimulator', 'watchsimulator'].each do |sdk|
  puts "PLATFORMS[#{sdk}]: #{PLATFORMS[sdk]}"
end
# macosx is NOT in PLATFORMS (nil → skip Fourflusher destination lookup)
puts "PLATFORMS[macosx] nil?: #{PLATFORMS['macosx'].nil?}"

# 4. Replicate the xcodebuild arg-building logic (extracted verbatim)
#    to verify %W interpolation and conditional destination appending.
def sim_args_for(sdk, deployment_target)
  args = %W(-project MyApp.xcodeproj -scheme MyFramework -configuration Release -sdk #{sdk})
  platform = PLATFORMS[sdk]
  args += Fourflusher::SimControl.new.destination(:oldest, platform, deployment_target) unless platform.nil?
  args
end

ios_args = sim_args_for('iphonesimulator', '12.0')
puts "ios_args length: #{ios_args.length}"
puts "ios_args includes -destination: #{ios_args.include?('-destination')}"
puts "ios_args sdk: #{ios_args[ios_args.index('-sdk') + 1]}"

mac_args = sim_args_for('macosx', nil)
puts "mac_args length: #{mac_args.length}"
puts "mac_args includes -destination: #{mac_args.include?('-destination')}"

# 5. user_options fetch pattern used in the post_install hook
user_options = {}
enable_dsym = user_options.fetch('dsym', true)
configuration = user_options.fetch('configuration', 'Debug')
puts "default dsym: #{enable_dsym}"
puts "default configuration: #{configuration}"

user_options2 = { 'dsym' => false, 'configuration' => 'Release' }
puts "custom dsym: #{user_options2.fetch('dsym', true)}"
puts "custom configuration: #{user_options2.fetch('configuration', 'Debug')}"
