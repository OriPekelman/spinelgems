ng = NGram.new
puts NGram::VERSION
puts ng.size
puts ng.word_separator.inspect
puts ng.padchar.inspect
puts ng.parse("hello").inspect

ng2 = NGram.new(size: 3, padchar: "-")
puts ng2.size
puts ng2.parse("abc").inspect
