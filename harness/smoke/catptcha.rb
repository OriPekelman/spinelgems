puts Catptcha::VERSION
js = Catptcha.puzzle_js
puts js.include?("catptcha_click")
puts js.include?("parentNode")
puts js.strip.start_with?("function catptcha_click")
