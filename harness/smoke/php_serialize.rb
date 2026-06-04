require 'php_serialize'

# --- serialize primitives ---
puts PHP.serialize(42)
puts PHP.serialize(3.14)
puts PHP.serialize(true)
puts PHP.serialize(false)
puts PHP.serialize(nil)
puts PHP.serialize("hello world")

# --- serialize array ---
puts PHP.serialize([1, 2, 3])

# --- serialize hash ---
h = {"name" => "Alice", "age" => 30}
puts PHP.serialize(h)

# --- round-trip: unserialize what we just serialized ---
arr_str = PHP.serialize([10, 20, 30])
arr_back = PHP.unserialize(arr_str)
puts arr_back.inspect

hash_str = PHP.serialize({"key" => "value", "num" => 7})
hash_back = PHP.unserialize(hash_str)
puts hash_back["key"]
puts hash_back["num"]

# --- unserialize a PHP-generated string (known-good fixture) ---
php_bool_true  = PHP.unserialize("b:1;")
php_bool_false = PHP.unserialize("b:0;")
puts php_bool_true
puts php_bool_false

php_float = PHP.unserialize("d:2.718;")
puts php_float

php_arr = PHP.unserialize("a:2:{i:0;s:3:\"foo\";i:1;s:3:\"bar\";}")
puts php_arr.inspect

# --- serialize_session ---
session = PHP.serialize_session({"user" => "Bob", "logged_in" => true})
puts session

# --- round-trip nested hash ---
nested = {"outer" => {"inner" => "deep"}}
nested_str = PHP.serialize(nested)
nested_back = PHP.unserialize(nested_str)
puts nested_back["outer"]["inner"]
