# smoke: danger-flutter_lint — exercise FlutterAnalyzeParser and FlutterViolation
# The gem's plugin.rb requires Danger::Plugin from the `danger` gem (not available).
# We stub the minimal base so flutter_lint/plugin.rb can load, then exercise
# FlutterAnalyzeParser and FlutterViolation directly.

# Stub Danger base before loading plugin
module Danger
  class Plugin; end
end

require 'flutter_lint/gem_version'
require 'flutter_lint/plugin'

# FlutterAnalyzeParser.violations takes an IO-like object with each_line.
require 'stringio'

report = <<~REPORT
  Analyzing...
  info • Use 'const' with the constructor to improve performance • lib/main.dart:10 • prefer_const_constructors
  warning • Avoid print calls in production code • lib/widgets/home.dart:42 • avoid_print
  error • Undefined name 'foo' • lib/utils/helper.dart:7 • undefined_identifier
REPORT

input = StringIO.new(report)
violations = Danger::FlutterAnalyzeParser.violations(input)

puts "violation count: #{violations.length}"

violations.each do |v|
  puts "rule=#{v.rule} file=#{v.file} line=#{v.line} description=#{v.description}"
end

# Test "No issues found!" short-circuit
no_violations = Danger::FlutterAnalyzeParser.violations(StringIO.new("Analyzing...\nNo issues found!\n"))
puts "no issues count: #{no_violations.length}"

# Test FlutterViolation struct construction and member access
v = Danger::FlutterViolation.new("some_rule", "Some description", "lib/foo.dart", 99)
puts "struct rule=#{v.rule} line=#{v.line} file=#{v.file}"
puts "struct members: #{Danger::FlutterViolation.members.join(',')}"

# Version constant
puts "version=#{FlutterLint::VERSION}"
