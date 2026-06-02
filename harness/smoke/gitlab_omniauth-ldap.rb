require_relative "lib/omniauth-ldap/version"

puts OmniAuth::LDAP::VERSION
puts OmniAuth::LDAP::VERSION.class
puts OmniAuth::LDAP::VERSION.split(".").length
puts OmniAuth::LDAP::VERSION.start_with?("2")
