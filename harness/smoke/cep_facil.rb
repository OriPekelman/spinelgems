require 'cep_facil'

# Test CepFacil::API.parse_zip_code - pure string logic, no network
puts CepFacil::API.parse_zip_code("01310-100")      # => "01310100"
puts CepFacil::API.parse_zip_code("01310100")        # => "01310100"
puts CepFacil::API.parse_zip_code("abc-12345-678xy") # => "12345678"
puts CepFacil::API.parse_zip_code("123")             # => "123"
puts CepFacil::API.parse_zip_code("1234567890")      # => "12345678" (truncated to 8)

# Test CepFacil::Address construction and methods
addr = CepFacil::Address.new("01310-100", "Avenida", "São Paulo", "SP", "Bela Vista", "Paulista")
puts addr.zip_code    # => "01310-100"
puts addr.city        # => "São Paulo"
puts addr.state       # => "SP"
puts addr.valid?      # => true
puts addr.full_format # => "Avenida Paulista, São Paulo - SP 01310-100, Brasil"

# Test with minimal address
addr2 = CepFacil::Address.new("20040-020", "Rua", "Rio de Janeiro", "RJ", "Centro", "Primeiro de Março")
puts addr2.street      # => "Primeiro de Março"
puts addr2.full_format # => "Rua Primeiro de Março, Rio de Janeiro - RJ 20040-020, Brasil"

# Version
puts CepFacil::VERSION # => "2.0.0"
