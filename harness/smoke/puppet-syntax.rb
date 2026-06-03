# frozen_string_literal: true
# Smoke: puppet-syntax — exercises PuppetSyntax::Hiera key/data/eyaml checks
# and module-level config accessors. No `puppet` gem needed for these paths.
require 'puppet-syntax'
require 'puppet-syntax/hiera'

hiera = PuppetSyntax::Hiera.new

# --- check_hiera_key ---
# valid namespaced key
puts hiera.check_hiera_key('module::param').inspect       # => nil

# symbol with leading colon (invalid for auto-lookup)
puts hiera.check_hiera_key(:':foo').inspect               # => string about leading '::'

# plain non-namespaced symbol (invalid)
puts hiera.check_hiera_key(:FooBar).inspect               # => string about symbols

# key that looks like a missing colon
puts hiera.check_hiera_key('module:param').inspect        # => 'Looks like a missing colon'

# valid simple key
puts hiera.check_hiera_key('foo_bar').inspect             # => nil (short key passes)

# --- check_hiera_data (broken function call detection) ---
# normal interpolation — no error
puts hiera.check_hiera_data('k', "%{lookup('ok')}").inspect   # => []

# broken: text after function call but before closing brace
puts hiera.check_hiera_data('k', "%{lookup('ok'):3306}").inspect # => [string]

# --- check_eyaml_blob ---
# check_eyaml_blob calls gsub! so we must pass mutable (non-frozen) strings
# no ENC marker -> nil (clean)
puts hiera.check_eyaml_blob(+'plain value').inspect       # => nil

# valid PKCS7 base64 blob (length divisible by 4, valid chars)
puts hiera.check_eyaml_blob(+'ENC[PKCS7,AAAA]').inspect  # => nil

# unpadded base64 (length % 4 != 0)
puts hiera.check_eyaml_blob(+'ENC[PKCS7,ABC]').inspect   # => string about unpadded

# unterminated ENC
puts hiera.check_eyaml_blob(+'ENC[PKCS7,AAAA').inspect   # => string about unterminated

# --- Module-level config accessors ---
orig = PuppetSyntax.fail_on_deprecation_notices
PuppetSyntax.fail_on_deprecation_notices = false
puts PuppetSyntax.fail_on_deprecation_notices.inspect    # => false
PuppetSyntax.fail_on_deprecation_notices = orig
puts PuppetSyntax.fail_on_deprecation_notices.inspect    # => true

puts PuppetSyntax.exclude_paths.first                     # => "spec/fixtures/**/*"
puts PuppetSyntax::VERSION                                # => 7.2.0
