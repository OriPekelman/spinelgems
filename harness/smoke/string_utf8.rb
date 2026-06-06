# encoding: utf-8
# Smoke test for string_utf8 gem (requires as 'string/utf8')
require 'string/utf8'

# Test 1: UTF-8 string already valid — utf8! should return itself
s1 = "hello world"
s1.utf8!
puts s1

# Test 2: Convert GB18030-encoded bytes for simplified Chinese "中文" to UTF-8
# \xD6\xD0\xCE\xC4 is "中文" in GB2312/GBK/GB18030
s2 = "\xD6\xD0\xCE\xC4".b
s2.utf8!
puts s2
puts $enc

# Test 3: Convert simplified Chinese "简体中文" from GB18030
s3 = "\xBC\xF2\xCC\xE5\xD6\xD0\xCE\xC4".b
s3.utf8!
puts s3

# Test 4: valid_encoding? check — result should be a valid UTF-8 string
puts s3.valid_encoding?

# Test 5: ENCODINGS constant is accessible
puts String::ENCODINGS.include?('utf-8')
puts String::ENCODINGS.first
