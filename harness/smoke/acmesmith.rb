# Smoke test for acmesmith-verisign (acmesmith plugin gem)
# Tests version constant, class structure, and non-network logic.
# Stubs for rest-client and acmesmith::Base are in the gem's lib/ dir.

require 'acmesmith-verisign/version'
require 'acmesmith/challenge_responders/verisign'

# 1. Version constant
puts "VERSION: #{AcmesmithVerisign::VERSION}"

# 2. Instantiate responder with config
config = { token: 'testtoken123', account_id: 'acct-001', ttl: 7200 }
responder = Acmesmith::ChallengeResponders::Verisign.new(config)
puts "Instantiated: #{responder.class}"

# 3. support? method — only public API besides respond/cleanup (which need network)
puts "supports dns-01: #{responder.support?('dns-01')}"
puts "supports http-01: #{responder.support?('http-01')}"

# 4. Private helpers via send (pure string manipulation, no network)
# canonicalize builds the FQDN for the ACME TXT record
stub_challenge = Object.new
stub_challenge.define_singleton_method(:record_name) { '_acme-challenge' }
stub_challenge.define_singleton_method(:record_content) { 'sometoken' }
stub_challenge.define_singleton_method(:record_type) { 'TXT' }

fqdn = responder.send(:canonicalize, 'example.com', stub_challenge)
puts "canonicalize: #{fqdn}"

# add_slash ensures paths start with /
puts "add_slash no-slash: #{responder.send(:add_slash, 'zones')}"
puts "add_slash with-slash: #{responder.send(:add_slash, '/zones')}"

# 5. find_record — pure array manipulation, no network
records = [
  { "rdata" => '"sometoken"', "resource_record_id" => 42 },
  { "rdata" => '"othertoken"', "resource_record_id" => 99 }
]
result = responder.send(:find_record, records, stub_challenge)
puts "find_record match: #{result.inspect}"
