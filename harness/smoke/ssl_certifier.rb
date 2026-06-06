require 'ssl_certifier'

# Verify the CA cert options constant is set with a non-empty path
ca_path = OpenURI::CaCertOptions[:ssl_ca_cert]
puts ca_path.end_with?('cacert.pem') ? "ca_cert: ends_with_cacert_pem" : "ca_cert: unexpected_path"
puts File.exist?(ca_path) ? "ca_cert_file: exists" : "ca_cert_file: missing"

# Verify the monkey-patch was applied (open_http aliased)
has_alias = OpenURI.respond_to?(:open_http_without_ca_cert, true)
puts has_alias ? "alias: present" : "alias: missing"

# Verify version constant
require 'ssl_certifier/version'
puts "version: #{SslCertifier::VERSION}"
