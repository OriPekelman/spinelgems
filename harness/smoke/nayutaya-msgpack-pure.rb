# smoke: nayutaya-msgpack-pure
# Exercises MessagePackPure.pack / unpack round-trip for all major types.
require 'msgpack_pure'

# Helper: hex-encode binary for deterministic output
def hex(s)
  s.bytes.map { |b| '%02x' % b }.join(' ')
end

# --- nil, booleans ---
puts hex(MessagePackPure.pack(nil))      # c0
puts hex(MessagePackPure.pack(true))     # c3
puts hex(MessagePackPure.pack(false))    # c2

# --- positive fixnum (0..127) ---
puts hex(MessagePackPure.pack(0))        # 00
puts hex(MessagePackPure.pack(42))       # 2a
puts hex(MessagePackPure.pack(127))      # 7f

# --- negative fixnum (-32..-1) ---
puts hex(MessagePackPure.pack(-1))       # ff
puts hex(MessagePackPure.pack(-32))      # e0

# --- uint8 (128..255) ---
puts hex(MessagePackPure.pack(200))      # cc c8

# --- int8 (-128..-33) ---
puts hex(MessagePackPure.pack(-100))     # d0 9c

# --- uint16 ---
puts hex(MessagePackPure.pack(1000))     # cd 03 e8

# --- int32 ---
puts hex(MessagePackPure.pack(-100000)) # d2 ff fe 79 60

# --- fixraw string ---
puts hex(MessagePackPure.pack("hi"))     # a2 68 69

# --- fixarray ---
puts hex(MessagePackPure.pack([1, 2, 3])) # 93 01 02 03

# --- fixmap (sorted by key) ---
puts hex(MessagePackPure.pack({"a" => 1, "b" => 2}))

# --- round-trip tests ---
[nil, true, false, 0, 42, -1, 200, 1000, -100000, "hello", [1,"x"], {"k"=>7}].each do |v|
  packed   = MessagePackPure.pack(v)
  unpacked = MessagePackPure.unpack(packed)
  puts "#{v.inspect} => #{unpacked.inspect} #{v == unpacked ? 'OK' : 'FAIL'}"
end
