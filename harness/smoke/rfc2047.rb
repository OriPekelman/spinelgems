# Smoke test for rfc2047 gem - RFC 2047 encoded word decoding

# Decode a base64-encoded word (UTF-8)
puts Rfc2047.decode("=?UTF-8?B?SGVsbG8gV29ybGQ=?=")

# Decode a quoted-printable encoded word (UTF-8)
puts Rfc2047.decode("=?UTF-8?Q?Hello_World?=")

# Decode a plain ASCII string (no encoding)
puts Rfc2047.decode("Hello World")

# Decode ISO-8859-1 base64-encoded word
puts Rfc2047.decode("=?iso-8859-1?B?dGVzdA==?=")

# Decode multiple words in same encoding (adjacent words merge)
puts Rfc2047.decode("=?UTF-8?Q?foo?= =?UTF-8?Q?bar?=")

# Verify WORD regex constant is present
puts Rfc2047::WORD.class
