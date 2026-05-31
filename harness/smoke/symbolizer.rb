puts Symbolizer.symbolize('a' => 'b').inspect
puts Symbolizer.symbolize('x' => 1, 'y' => 2).inspect
puts Symbolizer.symbolize('a' => {'b' => 'c'}).inspect
puts Symbolizer.symbolize('arr' => [1, 2, 3]).inspect
puts Symbolizer.symbolize('nested' => {'deep' => {'key' => 'val'}}).inspect
puts Symbolizer.symbolize({}).inspect
