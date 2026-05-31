require_relative "lib/platform"
puts Platform::OS.inspect
puts Platform::IMPL.inspect
puts Platform::ARCH.inspect
puts Platform::PLATFORMS.size
puts Platform::ARCHS.size
Platform.for_platform(:unix, :linux) { |os, impl, arch| puts "matched: #{os} #{impl}" }
