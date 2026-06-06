require 'wordpress_util'

# Test 1: basic paragraph wrapping — double newline becomes <p> tags
text1 = "Hello world.\n\nSecond paragraph."
result1 = WordpressUtil.wpautop(text1)
puts "TEST1: #{result1.strip}"

# Test 2: single newlines with br=true (default) become <br /> tags
text2 = "Line one.\nLine two.\nLine three."
result2 = WordpressUtil.wpautop(text2)
puts "TEST2: #{result2.strip}"

# Test 3: br=false — single newlines are NOT converted to <br />
text3 = "Only one paragraph.\nNo breaks."
result3 = WordpressUtil.wpautop(text3, false)
puts "TEST3: #{result3.strip}"

# Test 4: block-level tags are unwrapped from <p>
text4 = "<div>Inside div.</div>\n\nAfter div."
result4 = WordpressUtil.wpautop(text4)
puts "TEST4: #{result4.strip}"

# Test 5: pre tags are preserved unchanged
text5 = "Before.\n\n<pre>  code\n  here\n</pre>\n\nAfter."
result5 = WordpressUtil.wpautop(text5)
puts "TEST5_HAS_PRE: #{result5.include?('<pre>')}"
puts "TEST5_HAS_CODE_NEWLINE: #{result5.include?("  code\n  here")}"
