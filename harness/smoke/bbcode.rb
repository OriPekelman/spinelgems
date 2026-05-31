# Smoke test for bbcode gem (Ruby beautifier)
# Bbcode::TabStr and TabSize constants
puts Bbcode::TabStr.inspect
puts Bbcode::TabSize

# rb_make_tab: produces tab strings
puts Bbcode.rb_make_tab(0).inspect
puts Bbcode.rb_make_tab(1).inspect
puts Bbcode.rb_make_tab(-1).inspect

# beautify_string: simple indented code
src = ["module Foo", "def bar", "x = 1", "end", "end"]
result, err = Bbcode.beautify_string(src)
puts err
puts result
