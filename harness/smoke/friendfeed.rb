# Smoke test for the friendfeed gem
# Exercises the compat.rb try_convert class methods which are the
# standalone pure-Ruby logic. The FriendFeed::Client uses mechanize
# for actual API calls (not available), so we test the core compat layer.

require 'friendfeed'           # defines FriendFeed module with autoloads
require 'friendfeed/compat'    # standalone: try_convert on Hash/Array/String/IO

# --- FriendFeed module structure ---
puts FriendFeed.class
puts FriendFeed.constants.sort.map(&:to_s).join(',')

# --- Hash.try_convert ---
h = Hash.try_convert({a: 1, b: 2})
puts h.class
puts h[:a]
puts h[:b]
puts Hash.try_convert('not a hash').inspect

# --- Array.try_convert ---
a = Array.try_convert([10, 20, 30])
puts a.class
puts a.length
puts a.first
puts Array.try_convert(42).inspect

# --- String.try_convert ---
s = String.try_convert('hello')
puts s.class
puts s.upcase
puts String.try_convert(99).inspect

# --- IO.try_convert ---
io = IO.try_convert(STDOUT)
puts io.class
puts IO.try_convert('not io').inspect

# --- Custom to_ary conversion ---
class FakeLike
  def to_ary
    [7, 8, 9]
  end
end

result = Array.try_convert(FakeLike.new)
puts result.class
puts result.inspect

# --- Custom to_str conversion ---
class FakeStr
  def to_str
    'converted'
  end
end

result2 = String.try_convert(FakeStr.new)
puts result2.inspect
