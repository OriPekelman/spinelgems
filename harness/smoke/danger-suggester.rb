# Smoke: danger-suggester — Suggestion / Hunk / Change / File logic
# DangerPlugin requires 'danger' (external); the pure-Ruby suggester
# submodules (Suggestion, Change, Hunk, File) carry the real behaviour.
# git_diff is a runtime dep loaded by the lib files; external requires are
# ignored by Spinel (no load-path), so we test what's self-contained.

puts Danger::Suggester::VERSION

# 1. Suggestion#message — markdown suggestion fence
s = Danger::Suggester::Suggestion.new(
  content: "  x = 42\n  y = x + 1",
  line: 7,
  path: 'lib/calc.rb'
)
puts s.path
puts s.line
puts s.message
puts s.message.include?('suggestion')
