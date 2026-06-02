# Smoke: erb_lint gem — ERBLint::Stats (pure Ruby, no external deps)
require_relative "/home/oripekelman/.cache/spinel-compat/gems/erb_lint-0.9.0/lib/erb_lint/stats"

s = ERBLint::Stats.new(found: 3, corrected: 1, files: 5)
puts s.found
puts s.corrected
puts s.files
puts s.ignored
puts s.exceptions

s2 = ERBLint::Stats.new
puts s2.found
puts s2.linters
puts s2.autocorrectable_linters
