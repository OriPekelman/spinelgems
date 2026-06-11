pm = PasswordMasker.new("secret123")
puts pm.value
puts pm.to_s
puts pm.inspect
puts PasswordMasker::VERSION
pm.value = "newpassword"
puts pm.value
puts pm.to_s
