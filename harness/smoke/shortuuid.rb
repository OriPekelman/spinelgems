# Smoke test for shortuuid gem - deterministic API calls only
puts ShortUUID::VERSION
short = ShortUUID.shorten('12345678-1234-1234-1234-123456789abc')
puts short
puts ShortUUID.expand(short)
puts ShortUUID.encode(12345)
puts ShortUUID.decode('3D7')
puts ShortUUID.convert_decimal_to_alphabet(255)
puts ShortUUID.convert_alphabet_to_decimal('4F')
