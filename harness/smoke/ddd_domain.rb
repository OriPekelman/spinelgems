require 'ddd_domain'
require 'ddd_domain/version'

# ddd_domain is a Rails generator gem with no standalone public API.
# Its only standalone content is the VERSION constant and an empty module.
# The generator (DomainsGenerator < Rails::Generators::NamedBase) requires Rails.

puts DddDomain::VERSION
puts DddDomain.class
puts DddDomain.name
