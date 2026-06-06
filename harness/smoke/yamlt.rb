require 'yamlt'
require 'tempfile'

# --- Test 1: Parser::Line parses fragments and values ---
line1 = Yamlt::Parser::Line.new("en:\n")
puts "line1 fragment: #{line1.fragment}"
puts "line1 level: #{line1.level}"
puts "line1 value: #{line1.value.inspect}"

line2 = Yamlt::Parser::Line.new("  greeting: 'Hello World'\n")
puts "line2 fragment: #{line2.fragment}"
puts "line2 level: #{line2.level}"
puts "line2 value: #{line2.value}"

line3 = Yamlt::Parser::Line.new("  farewell: \"Goodbye\"\n")
puts "line3 fragment: #{line3.fragment}"
puts "line3 value: #{line3.value}"

line_empty = Yamlt::Parser::Line.new("\n")
puts "empty line: #{line_empty.empty?}"

line_comment = Yamlt::Parser::Line.new("# this is a comment\n")
puts "comment: #{line_comment.comment.strip}"

# --- Test 2: Parser::State accumulates values ---
state = Yamlt::Parser::State.new
[
  "en:\n",
  "  greeting: 'Hello'\n",
  "  farewell: \"Bye\"\n"
].each do |text|
  state.apply(Yamlt::Parser::Line.new(text))
end
state.flush

puts "language: #{state.language}"
puts "greeting: #{state.values['en.greeting']}"
puts "farewell: #{state.values['en.farewell']}"

# --- Test 3: Full Parser round-trip via Tempfile ---
yaml_content = <<~YAML
  en:
    welcome: "Welcome to the site"
    goodbye: "See you later"
    nested:
      title: "Nested Title"
YAML

Tempfile.create(['yamlt_smoke', '.yml']) do |f|
  f.write(yaml_content)
  f.flush
  parsed = Yamlt::Parser.new(f.path).parse
  puts "parsed language: #{parsed.language}"
  puts "parsed welcome: #{parsed.values['en.welcome']}"
  puts "parsed goodbye: #{parsed.values['en.goodbye']}"
  puts "parsed nested title: #{parsed.values['en.nested.title']}"
  puts "total values: #{parsed.values.size}"
end

# --- Test 4: Line serialization via as_text ---
line4 = Yamlt::Parser::Line.new("  title: \"My Title\"\n")
puts "serialized: #{line4.as_text.strip}"
