# Smoke: cocoapods-static-swift-framework
# Stubs the Pod namespace so we can exercise the monkey-patch logic
# without a full CocoaPods installation.

# Stub Pod module mimicking CocoaPods >= 1.7 structure
module Pod
  VERSION = '1.8.0'

  class Target
    class BuildType
      attr_reader :linkage

      def initialize(linkage)
        @linkage = linkage
      end
    end
  end

  class PodTarget
    def static_framework?
      false
    end
  end
end

# This loads gem_version.rb only (main.rb requires cocoapods which is absent)
require 'cocoapods-static-swift-framework'

# 1. VERSION constant
puts CocoapodsStaticSwiftFramework::VERSION

# 2. Load the static_pod patch via the load path (available via -Ilib)
require 'cocoapods-static-swift-framework/patch/static_pod'

# 3. After patch: Pod::Target::BuildType#linkage must return :static unconditionally
bt = Pod::Target::BuildType.new(:dynamic)
puts bt.linkage

bt2 = Pod::Target::BuildType.new(:static)
puts bt2.linkage

# 4. Gem::Version comparisons used by the patch's conditional
v_pod = Gem::Version.new(Pod::VERSION)
puts v_pod >= Gem::Version.new('1.7')
puts Gem::Version.new('1.6.0') < Gem::Version.new('1.7')
