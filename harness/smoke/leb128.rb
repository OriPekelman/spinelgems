# LEB128 encode/decode roundtrip smoke
# encode_unsigned returns a StringIO; read bytes out of it
sio = LEB128.encode_unsigned(0)
sio.pos = 0
puts sio.read.bytes.inspect

sio = LEB128.encode_unsigned(624485)
sio.pos = 0
puts sio.read.bytes.inspect

sio = LEB128.encode_unsigned(1)
sio.pos = 0
puts sio.read.bytes.inspect

# decode unsigned roundtrip
sio = LEB128.encode_unsigned(624485)
puts LEB128.decode_unsigned(sio)

# encode/decode signed
sio = LEB128.encode_signed(-123456)
puts LEB128.decode_signed(sio)

sio = LEB128.encode_signed(0)
sio.pos = 0
puts sio.read.bytes.inspect
