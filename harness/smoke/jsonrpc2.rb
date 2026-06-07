require 'jsonrpc2'
require 'jsonrpc2/types'

# Exercise JSONRPC2::Types.valid? with primitive type checks
iface = Class.new do
  def self.types; {}; end
  def self.name; 'TestInterface'; end
end

puts JSONRPC2::Types.valid?(iface, 'String', 'hello').inspect       # true
puts JSONRPC2::Types.valid?(iface, 'String', 42).inspect             # false
puts JSONRPC2::Types.valid?(iface, 'Integer', 7).inspect             # true
puts JSONRPC2::Types.valid?(iface, 'Integer', 3.14).inspect          # false
puts JSONRPC2::Types.valid?(iface, 'Number', 3.14).inspect           # true
puts JSONRPC2::Types.valid?(iface, 'Boolean', true).inspect          # true
puts JSONRPC2::Types.valid?(iface, 'Boolean', false).inspect         # true
puts JSONRPC2::Types.valid?(iface, 'Boolean', nil).inspect           # false
puts JSONRPC2::Types.valid?(iface, 'null', nil).inspect              # true
puts JSONRPC2::Types.valid?(iface, 'null', 0).inspect                # false
puts JSONRPC2::Types.valid?(iface, 'Array', [1, 2, 3]).inspect       # true
puts JSONRPC2::Types.valid?(iface, 'Object', { 'a' => 1 }).inspect   # true
puts JSONRPC2::Types.valid?(iface, 'Array[Integer]', [1, 2, 3]).inspect  # true
puts JSONRPC2::Types.valid?(iface, 'Array[Integer]', [1, 'x']).inspect   # false
puts JSONRPC2::Types.valid?(iface, 'Value', anything = Object.new).inspect # true

# Multi-type (comma-separated)
puts JSONRPC2::Types.valid?(iface, 'String,Integer', 42).inspect     # true
puts JSONRPC2::Types.valid?(iface, 'String,Integer', 'hi').inspect   # true
puts JSONRPC2::Types.valid?(iface, 'String,Integer', []).inspect     # false

# JsonObjectType: build a custom type and validate objects
person_type = JSONRPC2::JsonObjectType.new('Person', [])
person_type.string  'name', 'Full name'
person_type.integer 'age',  'Age in years'
person_type.optional { |t| t.string 'email', 'Email address' }

puts person_type.name                                                  # Person
puts person_type.fields.size.inspect                                   # 3

# Valid person
valid_person = { 'name' => 'Alice', 'age' => 30 }
puts person_type.valid_object?(iface, valid_person).inspect           # true

# Also valid with optional email
valid_person2 = { 'name' => 'Bob', 'age' => 25, 'email' => 'bob@example.com' }
puts person_type.valid_object?(iface, valid_person2).inspect          # true

# Missing required field
invalid_person = { 'name' => 'Charlie' }
puts person_type.valid_object?(iface, invalid_person).inspect         # false

# Wrong type for field
wrong_type_person = { 'name' => 'Dave', 'age' => 'not a number' }
puts person_type.valid_object?(iface, wrong_type_person).inspect      # false

# Date type validation
puts JSONRPC2::Types.valid?(iface, 'Date', '2024-01-15').inspect     # true
puts JSONRPC2::Types.valid?(iface, 'Date', '2024-13-99').inspect     # true (regex only)
puts JSONRPC2::Types.valid?(iface, 'Date', 'notadate').inspect       # false
