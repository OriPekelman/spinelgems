# Smoke test for terminal-notifier 2.0.0
# Tests the pure-logic notify_result method and LIST_FIELDS constant
# Uses only symbol-key hashes to avoid a Spinel mixed-hash-type codegen bug

puts TerminalNotifier::LIST_FIELDS.inspect
puts TerminalNotifier.notify_result('Test', {}).inspect
puts TerminalNotifier.notify_result('No, sir', {}).inspect
puts TerminalNotifier.notify_result('@timeout', {}).inspect
puts TerminalNotifier.notify_result('I like pie', {reply: true}).inspect
puts TerminalNotifier.notify_result('I may like pie', {}).inspect
puts TerminalNotifier.notify_result('', {}).inspect
