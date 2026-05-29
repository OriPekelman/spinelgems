# Smoke for grep-0.0.1 — Grep module
# The harness prepends: require_relative "lib/grep"

class GrepHelper
  include Grep
end

gh = GrepHelper.new

# Write a temp file and grep it
tmp = "/tmp/grep_smoke_test.txt"
File.write(tmp, "apple pie\nbanana split\napple cider\ncherry tart\n")

result = gh.grep(tmp, "apple")
puts result.map(&:chomp).sort.inspect

result2 = gh.grep(tmp, /banana/)
puts result2.map(&:chomp).inspect

puts Grep.class
