require 'rumm'
require 'rumm/exceptions'

# VERSION constant
puts Rumm::VERSION

# Raise and rescue the custom exception
begin
  raise Rumm::LoginRequired, "must authenticate first"
rescue Rumm::LoginRequired => e
  puts e.message
end

# Instantiate directly and check message
err = Rumm::LoginRequired.new("token expired")
puts err.message
puts err.is_a?(Exception)
puts err.is_a?(StandardError)
