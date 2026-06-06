require 'rubysl/tmpdir'

# Dir::Tmpname.make_tmpname is the core logic this gem contributes.
# Dir.tmpdir / Dir.mktmpdir use $SAFE which was removed in Ruby 3.x,
# so we test the parts that work correctly under modern Ruby.

# 1. make_tmpname with a String prefix: returns "prefix<date>-<pid>-<rand>"
name1 = Dir::Tmpname.make_tmpname("myprefix", nil)
puts "make_tmpname String: starts with prefix: #{name1.start_with?("myprefix")}"
puts "make_tmpname String: no n suffix: #{!name1.end_with?("-nil")}"

# 2. make_tmpname with Array [prefix, suffix]
name2 = Dir::Tmpname.make_tmpname(["foo", ".tmp"], nil)
puts "make_tmpname Array: starts with foo: #{name2.start_with?("foo")}"
puts "make_tmpname Array: ends with .tmp: #{name2.end_with?(".tmp")}"

# 3. make_tmpname with n counter appends -n
name3 = Dir::Tmpname.make_tmpname("pre", 7)
puts "make_tmpname with n=7: ends with -7: #{name3.end_with?("-7")}"

name4 = Dir::Tmpname.make_tmpname(["a", ".b"], 2)
puts "make_tmpname Array+n=2: contains -2: #{name4.include?("-2")}"
puts "make_tmpname Array+n=2: ends with .b: #{name4.end_with?(".b")}"

# 4. Invalid prefix_suffix raises ArgumentError
begin
  Dir::Tmpname.make_tmpname(42, nil)
  puts "no ArgumentError raised"
rescue ArgumentError => e
  puts "ArgumentError for invalid prefix: #{e.message.include?("unexpected prefix_suffix")}"
end

# 5. VERSION constant
puts "VERSION: #{RubySL::Tmpdir::VERSION}"
