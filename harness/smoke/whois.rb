# frozen_string_literal: true
# Smoke: whois — server lookup routing + Record API (no network)

require 'whois'

# 1. Version
puts Whois::VERSION

# 2. Server.guess for a plain TLD string returns an adapter for IANA
tld_adapter = Whois::Server.guess(".com")
puts tld_adapter.class
puts tld_adapter.host

# 3. Server.guess for a domain resolves the TLD adapter
domain_adapter = Whois::Server.guess("example.com")
puts domain_adapter.class
puts domain_adapter.type

# 4. Server.guess for an IPv4 address returns an IP adapter
ip_adapter = Whois::Server.guess("8.8.8.8")
puts ip_adapter.class
puts ip_adapter.type

# 5. Server.guess raises ServerNotSupported for email
begin
  Whois::Server.guess("user@example.com")
rescue Whois::ServerNotSupported => e
  puts "ServerNotSupported: #{e.message}"
end

# 6. Server.definitions returns an array of definitions for a type
tld_defs = Whois::Server.definitions(:tld)
puts tld_defs.is_a?(Array)
puts tld_defs.length > 0

# 7. Manually define a custom server and retrieve it
Whois::Server.define(:tld, "testsmoke", "whois.testsmoke.example")
custom = Whois::Server.find_for_domain("something.testsmoke")
puts custom.host

# 8. Record + Part: build a record without network, test content/match
part1 = Whois::Record::Part.new(body: "Domain Name: EXAMPLE.COM", host: "whois.verisign-grs.com")
part2 = Whois::Record::Part.new(body: "Registrar: TEST REGISTRAR", host: "whois.example-registrar.com")
record = Whois::Record.new(nil, [part1, part2])
puts record.to_s.include?("EXAMPLE.COM")
puts record.match?(/Registrar/)
puts record.match?(/nonexistent/)
puts record.content.split("\n").length

# 9. Error hierarchy
puts Whois::ServerNotFound.ancestors.include?(Whois::ServerError)
puts Whois::ServerError.ancestors.include?(Whois::Error)
puts Whois::Error.ancestors.include?(StandardError)
