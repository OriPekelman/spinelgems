require_relative "lib/companies_house/version"
require_relative "lib/companies_house/api_error"
require_relative "lib/companies_house/not_found_error"
require_relative "lib/companies_house/authentication_error"
require_relative "lib/companies_house/rate_limit_error"

puts CompaniesHouse::VERSION

err = CompaniesHouse::APIError.new("something went wrong")
puts err.message

nfe = CompaniesHouse::NotFoundError.new("company", "12345678")
puts nfe.message

ae = CompaniesHouse::AuthenticationError.new
puts ae.message

rle = CompaniesHouse::RateLimitError.new
puts rle.message
