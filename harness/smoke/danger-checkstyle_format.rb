require_relative "lib/checkstyle_format/gem_version"
require_relative "lib/checkstyle_format/checkstyle_error"

# CheckstyleFormat::VERSION
puts CheckstyleFormat::VERSION

# CheckstyleError is a Struct — exercise .new and field access
err = CheckstyleError.new("app/foo.rb", 42, 7, "warning", "Unused variable", "ruby.lint")
puts err.file_name
puts err.line
puts err.column
puts err.severity
puts err.message
puts err.source

# Exercise CheckstyleError.generate — strips base_path prefix from file name
parent_node = { name: "/home/ci/project/app/bar.rb" }
child_node  = { line: "10", column: "3", severity: "error", message: "Missing semicolon", source: "java.checkstyle" }
base_path   = "/home/ci/project/"

generated = CheckstyleError.generate(child_node, parent_node, base_path)
puts generated.file_name   # strips base_path prefix -> "app/bar.rb"
puts generated.line        # integer
puts generated.column      # integer
puts generated.severity
puts generated.message
puts generated.source

# column nil case
child_no_col = { line: "5", column: nil, severity: "info", message: "FYI", source: nil }
gen2 = CheckstyleError.generate(child_no_col, parent_node, base_path)
puts gen2.column.inspect   # nil
puts gen2.line
