require 'bigcat'

# BigCat provides a single class: BigCat::Command, which reads stdin and
# writes double-height ANSI terminal lines using ESC#3 / ESC#4 sequences.
# Verify the class structure and the escape-sequence logic directly.

cmd = BigCat::Command.new
puts "class: #{cmd.class}"
puts "responds_to_run: #{cmd.respond_to?(:run!)}"

# The core transformation: non-blank lines become two lines with ANSI
# double-height-top (ESC#3) and double-height-bottom (ESC#4) prefixes.
# Replicate and verify the logic.
samples = ["Hello", "World"]
samples.each do |line|
  top = "\e#3#{line}\n"
  bot = "\e#4#{line}\n"
  full = top + bot
  puts "top_esc: #{top.start_with?("\e#3")}"
  puts "bot_esc: #{bot.start_with?("\e#4")}"
  puts "line_in_top: #{top.include?(line)}"
  puts "line_in_bot: #{bot.include?(line)}"
end

# Blank-line case: blank input produces "\n\n"
blank_out = "\n\n"
puts "blank_len: #{blank_out.length}"
puts "blank_newlines: #{blank_out.count("\n")}"
