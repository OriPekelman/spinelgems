puts RgGen::VERSION
puts RgGen::VERSION.class
puts RgGen::VERSION.split('.').length
puts RgGen::VERSION.start_with?('0.')
puts RgGen.const_defined?(:VERSION)
