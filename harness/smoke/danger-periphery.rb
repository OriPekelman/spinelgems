# frozen_string_literal: true

require_relative "lib/danger_periphery/version"
require_relative "lib/periphery/scan_result"

puts DangerPeriphery::VERSION

r = Periphery::ScanResult.new("foo/bar.swift", 10, 5, "unused")
puts r.path
puts r.line
puts r.column
puts r.message
puts Periphery::ScanResult.members.sort.inspect
