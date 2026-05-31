puts PostalCode::VERSION
puts PostalCode.valid_format?("10001")
puts PostalCode.valid_format?("10001-1234")
puts PostalCode.valid_format?("1234")
puts PostalCode.valid_format?("abc12")
puts PostalCode.valid_format?("100011")
puts PostalCode.valid_format?("00000")
