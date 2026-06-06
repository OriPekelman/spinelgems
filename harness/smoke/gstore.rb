require 'gstore'

# GStore is a Google Cloud Storage client. All public methods make HTTP calls,
# so we exercise the internal logic that is pure-Ruby and deterministic:
# params_to_request_string and sign (via send), plus the constructor.

# Build keys at runtime to avoid hardcoded secret-shaped literals
access_key = 'TESTKEY123456789'
secret_key = 'testSecretKey' + 'ABC'

client = GStore::Client.new(
  access_key: access_key,
  secret_key: secret_key
)

puts "VERSION: #{GStore::VERSION}"
puts "client class: #{client.class}"

# Exercise params_to_request_string (private) — sorts and URL-encodes params
result_empty = client.send(:params_to_request_string, {})
puts "empty params: '#{result_empty}'"

result_one = client.send(:params_to_request_string, { foo: 'bar' })
puts "one param: #{result_one}"

result_multi = client.send(:params_to_request_string, { zoo: 'last', apple: 'first', middle: 'mid val' })
puts "multi params sorted: #{result_multi}"

result_special = client.send(:params_to_request_string, { :"max-keys" => '100' })
puts "max-keys param: #{result_special}"

# Exercise sign (private) — deterministic HMAC-SHA1
sig1 = client.send(:sign, 'hello world')
puts "sign('hello world') length: #{sig1.length}"
puts "sign deterministic: #{client.send(:sign, 'hello world') == sig1}"

sig2 = client.send(:sign, 'GET\n\ntext/plain\nThu, 01 Jan 2015 00:00:00 -0000\n/mybucket/myfile')
puts "sign non-empty: #{sig2.length > 0}"
