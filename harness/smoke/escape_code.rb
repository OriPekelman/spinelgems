require 'escape_code'

# 1. Parse a single escape code and inspect its properties
code = EscapeCode::Code.parse("\e[31m")
puts code.type         # => m
puts code.sgr?         # => true
puts code.args.inspect # => ["31"]

sgr = code.sgr_commands.first
puts sgr.foreground_color? ? "yes" : "no"  # => yes
puts sgr.color.inspect                      # => :red

# 2. SgrCommand bold detection
bold_code = EscapeCode::Code.parse("\e[1m")
puts bold_code.sgr_commands.first.bold? # => true

# 3. Reset via explicit 0 argument produces a reset SgrCommand
reset_code = EscapeCode::Code.parse("\e[0m")
puts reset_code.sgr_commands.first.reset? # => true

# 4. Scanner over a mixed string (text + colors + explicit reset)
text = "Hello \e[32mworld\e[0m!"
tokens = EscapeCode::Scanner.new(text).scan.to_a
tokens.each do |t|
  if t.is_a?(EscapeCode::Code)
    puts "code:#{t.type}:#{t.args.inspect}"
  else
    puts "str:#{t.inspect}"
  end
end

# 5. HtmlFormatter produces HTML with span classes
formatter = EscapeCode::HtmlFormatter.new("\e[1m\e[34mBold Blue\e[0m Normal")
puts formatter.generate
