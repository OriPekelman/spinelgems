# frozen_string_literal: true

# brasilapi is a network API wrapper; only constants and class hierarchy are
# dependency-free and deterministic.
puts BrasilAPI::VERSION
puts BrasilAPI::Base::BASE_URL
puts BrasilAPI::Bank.superclass.name
puts BrasilAPI::Address.superclass.name
puts BrasilAPI::Holiday.superclass.name
puts BrasilAPI::Error.superclass.name
puts BrasilAPI::NotFound.superclass.name
