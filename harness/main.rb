# Phase-1 sanity: load vendored deps through the generated manifest and confirm
# the structure compiles + runs under Spinel (no behaviour exercised here).
require_relative "vendor/spinel/deps"
puts "spinel-harness: vendored deps loaded via deps.rb"
