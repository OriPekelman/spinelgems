# jpbuilder smoke — ActionView JSONP template handler
# jpbuilder is a Rails plugin: jpbuilder.rb is a no-op without ActionView::Template.
# The handler itself (jpbuilder-handler.rb) requires jbuilder (not available standalone).
# We exercise: the conditional load guard, and the core string-encoding logic
# embedded in JPbuilderHandler.call, replicated inline.

require 'jpbuilder'

# jpbuilder.rb only loads the handler if ActionView::Template is defined.
# Without Rails, nothing is defined — this is expected behaviour.
puts defined?(JPbuilderHandler).inspect   # => nil

# Replicate the key logic from JPbuilderHandler.call (the JSONP encoding):
# result.each_char.to_a.map { |chr| chr.ord > 1000 ? "\\u#{"%4.4x" % chr.ord}" : chr }.join
def jsonp_encode(str)
  str.each_char.to_a.map { |chr| chr.ord > 1000 ? "\\u#{'%4.4x' % chr.ord}" : chr }.join
end

# ASCII text passes through unchanged
puts jsonp_encode('hello world')           # => hello world

# Non-ASCII but ord <= 1000 passes through
puts jsonp_encode('café')             # => café (if present, otherwise literal)

# High-ord characters get escaped (simulate CJK character U+4E2D = 20013 > 1000)
cjk = "中"
puts jsonp_encode(cjk)                     # => 中

# Mixed: ASCII + high-ord
puts jsonp_encode("hello中world")      # => hello中world

# Simulate the callback-wrapping branch logic
def wrap_jsonp(result, callback)
  if callback && !callback.empty?
    "/**/#{callback}(#{result});"
  else
    result
  end
end

puts wrap_jsonp('{"key":"val"}', 'myCallback')   # => /**/myCallback({"key":"val"});
puts wrap_jsonp('{"key":"val"}', nil)             # => {"key":"val"}
puts wrap_jsonp('{"key":"val"}', '')              # => {"key":"val"}
