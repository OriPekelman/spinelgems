require 'dukpt'

# DUKPT (Derived Unique Key Per Transaction) smoke
# Uses ANSI X9.24 test vectors.
# Note: single-DES (des-cbc / des-ecb) is disabled in OpenSSL 3.0,
# so derive_key / full decrypt are unavailable; we smoke the reachable surface:
# IPEK derivation (triple-DES), mask constants, PEK/DEK key transforms.

include DUKPT::Encryption
self.cipher_mode = 'cbc'

# 1. Mask constants (pure arithmetic)
ksn_int = "FFFF9876543210E00008".to_i(16)
puts "LS16: #{(ksn_int & LS16_MASK).to_s(16).rjust(20, '0')}"
# => 00009876543210e00008
puts "REG8: #{(ksn_int & REG8_MASK).to_s(16).rjust(20, '0')}"
# => 00009876543210e00000
puts "REG3: #{(ksn_int & REG3_MASK).to_s(16)}"
# => 8

# 2. IPEK derivation (triple-DES path — works in OpenSSL 3.0+)
bdk = "0123456789ABCDEFFEDCBA9876543210"
ksn = "FFFF9876543210E00008"
ipek = derive_IPEK(bdk, ksn)
puts "IPEK: #{ipek}"
# expected: 6ac292faa1315b4d858ab3a3d7d5933a

# 3. PEK from key (XOR-only transform, no crypto)
pek = pek_from_key(ipek)
puts "PEK: #{pek}"
# expected: 6ac292faa1315bb2858ab3a3d7d593c5

# 4. DEK from key (XOR + triple-DES)
dek = dek_from_key(ipek)
puts "DEK: #{dek}"
# expected: ea2b1195b02d1e77a14ced05952df86b

# 5. Decrypter instantiation and version
d = DUKPT::Decrypter.new(bdk, "cbc")
puts "BDK match: #{d.bdk == bdk}"
puts "VERSION: #{DUKPT::VERSION}"
