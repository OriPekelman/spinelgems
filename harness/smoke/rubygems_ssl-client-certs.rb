require 'rubygems_ssl-client-certs'

# Test 1: module and version constant
puts Rubygems::ClientCerts::VERSION

# The gem is a RubyGems plugin that patches Gem::ConfigFile with ssl_* accessors
# and a set_ssl_vars method. Test that patching worked and the accessors return
# the correct values from a .gemrc file.
require 'tempfile'

# Use YAML format that Gem::ConfigFile.load_file understands (symbol-key style)
gemrc = <<~YAML
  ---
  :ssl_verify_mode: peer
  :ssl_ca_cert: /path/to/ca.pem
  :ssl_client_cert: /path/to/client.pem
YAML

Tempfile.create(['gemrc', '']) do |f|
  f.write(gemrc)
  f.flush

  cfg = Gem::ConfigFile.new(["--config-file", f.path])

  # These readers were added by the rubygems_plugin.rb patch.
  # In modern RubyGems (>= 2.1) they are also built in; the plugin
  # is a backport for older versions, so the accessors must be present.
  puts cfg.ssl_verify_mode.inspect
  puts cfg.ssl_ca_cert.inspect
  puts cfg.ssl_client_cert.inspect
end
