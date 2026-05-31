require_relative "lib/checkstyle_format/gem_version"
require_relative "lib/checkstyle_format/checkstyle_error"

puts CheckstyleFormat::VERSION
puts CheckstyleFormat::VERSION.class

e = CheckstyleError.new("src/Foo.java", 42, 7, "warning", "bad code", "com.example")
puts e.file_name
puts e.line
puts e.column
puts e.severity
puts e.message
puts e.source
