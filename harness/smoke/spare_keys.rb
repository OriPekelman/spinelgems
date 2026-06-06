require 'spare_keys'

# spare_keys is a macOS-only gem that wraps the `security` CLI tool and
# the macOS sysctl kern.osrelease call. On Linux we test the purely-Ruby
# path helpers that don't shell out.

# Test 1: class loads and exposes its public API
puts SpareKeys.respond_to?(:use_keychain, true).inspect    # => true
puts SpareKeys.respond_to?(:temp_keychain, true).inspect   # => true

# Test 2: expand_keychain_path — pure Ruby path logic (no shelling out)
# Basename-only: prepends ~/Library/Keychains
expanded = SpareKeys.send(:expand_keychain_path, 'test.keychain')
puts expanded.start_with?(File.expand_path('~')).inspect   # => true
puts expanded.include?('Library/Keychains').inspect        # => true
puts expanded.end_with?('test.keychain').inspect           # => true

# Absolute path: just expands ~
expanded_abs = SpareKeys.send(:expand_keychain_path, '/tmp/my.keychain')
puts expanded_abs                                          # => /tmp/my.keychain

# Relative path treated as basename when no directory component
expanded2 = SpareKeys.send(:expand_keychain_path, 'other.keychain')
puts (expanded2 != 'other.keychain').inspect               # => true (was expanded)
puts expanded2.end_with?('other.keychain').inspect         # => true
