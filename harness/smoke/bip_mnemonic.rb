require 'bip_mnemonic'

# Use fixed entropy so output is deterministic (no OpenSSL::Random calls)
ENTROPY_HEX = 'a9caefa8a8d987ac4e82a23e3a5e4f21'

# 1. entropy -> mnemonic
mnemonic = BipMnemonic.to_mnemonic(entropy: ENTROPY_HEX)
puts "mnemonic: #{mnemonic}"
puts "word_count: #{mnemonic.split(' ').length}"

# 2. mnemonic -> entropy (round-trip)
recovered = BipMnemonic.to_entropy(mnemonic: mnemonic)
puts "entropy_roundtrip: #{recovered}"
puts "roundtrip_ok: #{recovered == ENTROPY_HEX}"

# 3. mnemonic -> seed (PBKDF2 derivation)
seed = BipMnemonic.to_seed(mnemonic: mnemonic, password: 'TREZOR')
puts "seed_prefix: #{seed[0, 16]}"

# 4. no-password seed differs from password seed
seed_no_pass = BipMnemonic.to_seed(mnemonic: mnemonic)
puts "seeds_differ: #{seed != seed_no_pass}"

# 5. Error handling - checksum mismatch on invalid mnemonic
begin
  BipMnemonic.to_entropy(mnemonic: 'zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo abandon')
  puts "checksum_guard: no_error"
rescue SecurityError => e
  puts "checksum_guard: #{e.message}"
end
