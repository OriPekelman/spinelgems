# frozen_string_literal: true

require 'security'

# 1. VERSION constant
puts Security::VERSION

# 2. Keychain::DOMAINS — the four macOS keychain scopes
puts Security::Keychain::DOMAINS.inspect

# 3. Keychain instance — filename attribute reader
kc = Security::Keychain.new('/Library/Keychains/System.keychain')
puts kc.filename

# 4. Exercise the private password_from_output parser via send
# Uses text-format password line only (avoids hex-blob branch that needs Array#pack)
raw = <<~OUTPUT
  keychain: "/Users/test/Library/Keychains/login.keychain-db"
  class: "genp"
  attributes:
      "acct"<blob>="myaccount"
      "svce"<blob>="myservice"
      "desc"<blob>="my description"
  password: "s3cr3t"
OUTPUT

pw = Security::GenericPassword.send(:password_from_output, raw)
puts pw.keychain.filename
puts pw.attributes['acct']
puts pw.attributes['svce']
puts pw.password

# 5. flags_for_options — maps symbolic option aliases to flag letters
# Tests the alias resolution logic (account->a, service->s, comment->j)
flags = Security::GenericPassword.send(:flags_for_options, { account: 'alice', service: 'myapp', comment: 'test note' })
puts flags

# 6. error-path: output starting with "security: " returns nil
result = Security::GenericPassword.send(:password_from_output, "security: SecKeychainSearchCopyNext: The specified item could not be found in the keychain.")
puts result.nil?
