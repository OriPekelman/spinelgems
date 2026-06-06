require 'viacep'

# 1. Exception hierarchy
puts ViaCep::Error.superclass.name
puts ViaCep::ApiRequestError.superclass.name

# 2. VERSION constant
puts ViaCep::VERSION

# 3. ArgumentError on nil CEP
begin
  ViaCep::Address.new(nil)
rescue ArgumentError => e
  puts "nil: #{e.message}"
end

# 4. ArgumentError on short CEP (too few digits)
begin
  ViaCep::Address.new('1234')
rescue ArgumentError => e
  puts "short: #{e.message}"
end

# 5. ArgumentError on CEP with letters stripped leaving wrong length
begin
  ViaCep::Address.new('abc-12345')  # 5 digits after stripping
rescue ArgumentError => e
  puts "alpha-short: #{e.message}"
end

# 6. ArgumentError on 9-digit CEP
begin
  ViaCep::Address.new('123456789')
rescue ArgumentError => e
  puts "long: #{e.message}"
end

# 7. Formatted CEP with hyphens strips correctly — still invalid length here (7 digits)
begin
  ViaCep::Address.new('1234-567')  # 7 digits
rescue ArgumentError => e
  puts "formatted-short: #{e.message}"
end

# 8. Service::BASE_URL constant
puts ViaCep::Service::BASE_URL
