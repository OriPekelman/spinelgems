require 'apns'

# Smoke test for jtv-apns: exercise pure-logic methods that don't require
# a network connection or certificate file.

# 1. Module-level configuration accessors (default values)
puts APNS.host
puts APNS.port
puts APNS.feedback_host
puts APNS.feedback_port
puts APNS.pem.inspect
puts APNS.pass.inspect
puts APNS.cache_connections.inspect

# Set config values and read them back
APNS.host = 'gateway.push.apple.com'
APNS.port = 2195
puts APNS.host
puts APNS.port

# 2. packaged_message with a String
msg_str = APNS.send(:packaged_message, 'Hello World')
puts msg_str

# 3. packaged_message with a Hash (the aps payload)
msg_hash = APNS.send(:packaged_message, { aps: { alert: 'Test', badge: 1 } })
puts msg_hash

# 4. packaged_token: strips spaces/brackets and packs the hex string
token = 'a1b2 c3d4 <e5f6> 0102 0304 0506 0708 090a 0b0c 0d0e 0f10 1112 1314 1516 1718'
packed = APNS.send(:packaged_token, token)
# unpack back to hex for deterministic printed output
puts packed.unpack1('H*')

# 5. packaged_notification returns a binary blob; verify structure
token2 = '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff'
notif = APNS.send(:packaged_notification, token2, 'ping')
# First byte is command byte (0), confirm and print length
puts notif.bytes.first
puts notif.bytesize

# 6. parse_feedback_tuple round-trip
# Build a feedback tuple: 4-byte big-endian timestamp + 2-byte length (32) + 32-byte token
ts = 1_600_000_000
raw_token = ['deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef'].pack('H*')
tuple_data = [ts, 32].pack('N1n1') + raw_token
fb = APNS.send(:parse_feedback_tuple, tuple_data)
puts fb[:length]
puts fb[:feedback_at].class
puts fb[:device_token]

# 7. has_notification_connection? when no connection cached
puts APNS.has_notification_connection?.inspect
