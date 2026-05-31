# cloudfront-signer smoke — constants + unconfigured state checks
puts Aws::CF::VERSION
puts Aws::CF::Signer.is_configured?
puts Aws::CF::Signer.default_expires
Aws::CF::Signer.default_expires = 7200
puts Aws::CF::Signer.default_expires
Aws::CF::Signer.key_pair_id = "TESTPAIRID"
puts Aws::CF::Signer.key_pair_id
