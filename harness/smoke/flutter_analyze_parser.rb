require 'flutter_analyze_parser'

# Smoke 1: no issues
no_issues_input = "Analyzing...\nNo issues found!\n"
result = FlutterAnalyzeParser.violations(no_issues_input)
puts result.length  # => 0

# Smoke 2: real violations
analyze_output = <<~OUTPUT
  Analyzing...
  info • Avoid print calls in production code • lib/main.dart:42 • avoid_print
  info • Prefer const constructors • lib/widgets/button.dart:7 • prefer_const_constructors
OUTPUT

violations = FlutterAnalyzeParser.violations(analyze_output)
puts violations.length  # => 2

v0 = violations[0]
puts v0.rule          # => avoid_print
puts v0.description   # => Avoid print calls in production code
puts v0.file          # => lib/main.dart
puts v0.line          # => 42

v1 = violations[1]
puts v1.rule          # => prefer_const_constructors
puts v1.file          # => lib/widgets/button.dart
puts v1.line          # => 7

# Smoke 3: struct responds to members
puts FlutterViolation.members.sort.join(",")  # => description,file,line,rule
