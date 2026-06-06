# frozen_string_literal: true
# smoke: blobby — InMemoryStore read/write/exists/delete + KeyConstraint validation
require "blobby"

# --- InMemoryStore via Blobby.store URI ---
store = Blobby.store("mem://")
puts store.available?                        # => true

obj = store["hello/world"]
puts obj.exists?                             # => false

obj.write("hello content")
puts obj.exists?                             # => true
puts obj.read                                # => hello content

obj2 = store["data/binary"]
obj2.write("binary\x00data")
puts obj2.read.bytesize                      # => 12

deleted = obj.delete
puts deleted                                 # => true
puts obj.exists?                             # => false

deleted_again = obj.delete
puts deleted_again                           # => false

# --- KeyConstraint: valid and invalid keys ---
puts Blobby::KeyConstraint.allows?("valid/key")   # => true
puts Blobby::KeyConstraint.allows?("")             # => false (blank)
puts Blobby::KeyConstraint.allows?("/leading")     # => false (leading slash)
puts Blobby::KeyConstraint.allows?("trailing/")   # => false (trailing slash)
puts Blobby::KeyConstraint.allows?("double//slash") # => false (double slash)
puts Blobby::KeyConstraint.allows?("has:colon")   # => false (colon)

# --- Write via IO-like object (respond_to?(:read)) ---
store2 = Blobby::InMemoryStore.new
require "stringio"
sio = StringIO.new("io content")
store2["io/key"].write(sio)
puts store2["io/key"].read                   # => io content

# --- KeyConstraint must_allow! raises on bad key ---
begin
  Blobby::KeyConstraint.must_allow!("/bad")
  puts "no error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"        # => ArgumentError: invalid key: "/bad"
end
