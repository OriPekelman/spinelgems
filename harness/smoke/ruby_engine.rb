require 'ruby_engine'

# Exercise RubyEngine public API — checks real logic, not just constants.

# 1. to_s / inspect — must return a non-empty string matching RUBY_ENGINE
engine_str = RubyEngine.to_s
puts "engine: #{engine_str}"
puts "inspect_eq_to_s: #{RubyEngine.inspect == engine_str}"

# 2. is? with exact string — check both matching and non-matching cases
puts "is_ruby: #{RubyEngine.is?('ruby')}"
puts "is_jruby: #{RubyEngine.is?('jruby')}"

# 3. is? with regex — /ruby/ matches 'ruby' but not 'jruby' or 'truffleruby'?
#    Actually /ruby/ matches all three — we just check the predicate works.
puts "is_regex_ruby: #{RubyEngine.is?(/ruby/)}"
puts "is_regex_noexist: #{RubyEngine.is?(/doesnotexist_xyz/)}"

# 4. Boolean engine predicates — exactly one of these should map to current engine,
#    all should return a boolean (true/false).
puts "mri: #{RubyEngine.mri?}"
puts "jruby: #{RubyEngine.jruby?}"
puts "rubinius: #{RubyEngine.rubinius?}"
puts "truffleruby: #{RubyEngine.truffleruby?}"

# 5. Alias checks — ruby? and cruby? should equal mri?
puts "ruby_alias: #{RubyEngine.ruby? == RubyEngine.mri?}"
puts "cruby_alias: #{RubyEngine.cruby? == RubyEngine.mri?}"

# 6. to_s should equal the RUBY_ENGINE constant itself
puts "matches_ruby_engine: #{RubyEngine.to_s == RUBY_ENGINE}"
