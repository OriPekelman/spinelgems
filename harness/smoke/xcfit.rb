# xcfit smoke: XCFit is a Thor-based CLI for iOS/Xcode template management.
# XCFit::VERSION is in lib/XCFit/version.rb; XCFit::Main inherits from Thor.
# The only lib code without external deps is the VERSION constant.

puts XCFit::VERSION
puts XCFit::VERSION.split(".").map(&:to_i).sum
puts XCFit.is_a?(Module)
puts XCFit::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "semver-ok" : "semver-fail"
