# Smoke test for json_web_token gem
# Uses alg:'none' (no OpenSSL) and pure Util methods

# Util.symbolize_keys
h = JsonWebToken::Util.symbolize_keys({'a' => 1, 'b' => '2', c: '3'})
puts h[:a]
puts h[:b]
puts h[:c]

# Util.constant_time_compare?
puts JsonWebToken::Util.constant_time_compare?('hello', 'hello')
puts JsonWebToken::Util.constant_time_compare?('hello', 'world')

# sign + verify round-trip with alg:'none' (no crypto, no OpenSSL)
claims = {sub: 'test', iat: 1000}
jwt = JsonWebToken.sign(claims, {alg: 'none'})
# JWT is deterministic for fixed claims with alg:none
puts jwt
result = JsonWebToken.verify(jwt, {alg: 'none'})
puts result[:ok][:sub]
puts result[:ok][:iat]
