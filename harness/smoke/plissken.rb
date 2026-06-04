# frozen_string_literal: true

require 'plissken'

# Test 1: simple camelCase string keys
h1 = { "firstName" => "John", "lastName" => "Doe", "emailAddress" => "john@example.com" }
puts h1.to_snake_keys.inspect

# Test 2: PascalCase/CamelCase keys
h2 = { "UserName" => "alice", "HttpResponseCode" => 200, "XMLParser" => true }
puts h2.to_snake_keys.inspect

# Test 3: symbol keys
h3 = { firstName: "Bob", lastName: "Smith", phoneNumber: "555-1234" }
puts h3.to_snake_keys.inspect

# Test 4: nested hash
h4 = { "userData" => { "firstName" => "Carol", "homeAddress" => { "zipCode" => "10001" } } }
puts h4.to_snake_keys.inspect

# Test 5: array of hashes
arr = [{ "productId" => 1, "productName" => "Widget" }, { "productId" => 2, "productName" => "Gadget" }]
puts arr.to_snake_keys.inspect

# Test 6: non-string/symbol keys pass through unchanged
h6 = { 42 => "numeric_key", "normalKey" => "value" }
puts h6.to_snake_keys.inspect
