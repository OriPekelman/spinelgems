# frozen_string_literal: true
# Smoke: paygate-ruby — exercises currency/locale mapping, Configuration,
# AES key-expansion/cipher, and AesCtr encrypt/decrypt round-trip.

require 'paygate-ruby'

# 1. VERSION
puts "version: #{Paygate::VERSION}"

# 2. mapped_currency — various inputs
puts Paygate.mapped_currency(nil)          # => WON (nil → default)
puts Paygate.mapped_currency('KRW')        # => WON
puts Paygate.mapped_currency('USD')        # => USD
puts Paygate.mapped_currency(:EUR)         # => EUR

# 3. mapped_locale — symbol-keyed YAML hash (keys are strings in config.yml)
puts Paygate.mapped_locale('en')           # => US
puts Paygate.mapped_locale('ko')           # => KR
puts Paygate.mapped_locale('ja')           # => JP
puts Paygate.mapped_locale('unknown')      # => US (default)
puts Paygate.mapped_locale(nil)            # => US (nil key → default)

# 4. INTL_BRANDS_MAP constant
puts Paygate::INTL_BRANDS_MAP[:visa]       # => 2Z0
puts Paygate::INTL_BRANDS_MAP[:mastercard] # => 2Y0

# 5. Configuration mode
cfg = Paygate::Configuration.new
puts cfg.mode                              # => live
cfg.mode = :sandbox
puts cfg.mode                              # => sandbox

# 6. AES low-level: key expansion + cipher must be deterministic
key = [0] * 16  # 128-bit zero key
w   = Paygate::Aes.key_expansion(key)
puts w.length                              # => 44
input = (0..15).to_a
out   = Paygate::Aes.cipher(input, w)
# Print first 4 bytes of ciphertext as hex (known AES test vector fragment)
puts out[0, 4].map { |b| b.to_s(16).rjust(2, '0') }.join

# 7. AesCtr round-trip — use a fixed password; encrypt then decrypt
plaintext = 'hello paygate'
password  = 'testpassword123'
bits      = 128
encrypted = Paygate::AesCtr.encrypt(plaintext, password, bits)
decrypted = Paygate::AesCtr.decrypt(encrypted, password, bits)
puts decrypted == plaintext ? 'roundtrip:ok' : "roundtrip:FAIL(#{decrypted.inspect})"
