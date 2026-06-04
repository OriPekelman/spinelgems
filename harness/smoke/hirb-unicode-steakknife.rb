# hirb-unicode-steakknife smoke
# This gem provides unicode-aware string utilities (size/slice/ljust/rjust)
# as an extension to hirb's Hirb::String class, patching it to measure
# display width of Unicode characters correctly.
#
# The gem requires 'hirb' and 'unicode/display_width' — both unavailable.
# We stub the minimum required so the gem's own StringUtil logic runs.

# Stub unicode display_width: for ASCII, display_width == length
class String
  def display_width
    length
  end
end

# Stub Hirb::String (hirb provides this; we can't require it)
module Hirb
  String = ::String
end

# Load the gem's own files via require_relative from the gem lib path
$LOAD_PATH.unshift File.expand_path('../../../.cache/spinel-compat/gems/hirb-unicode-steakknife-0.0.9/lib', __dir__)

require 'hirb/unicode/version'
require 'hirb/unicode/string_util'

puts Hirb::Unicode::VERSION

# After the extend, StringUtil methods are class methods on Hirb::String
puts Hirb::String.size("hello")           # => 5
puts Hirb::String.slice("hello world", 0, 5)   # => "hello"
puts Hirb::String.ljust("hi", 8).inspect  # => "hi      "
puts Hirb::String.rjust("hi", 8).inspect  # => "      hi"

# Slice with offset
puts Hirb::String.slice("abcdefgh", 2, 3) # => "cde"

# Edge: empty string
puts Hirb::String.ljust("", 4).inspect    # => "    "
