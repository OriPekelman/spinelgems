# ZipcodeJa smoke — exercises ZipcodeJa.find with inputs that return nil
# before any CSV I/O (regex check fires first for non-7-digit inputs)

puts ZipcodeJa.find("123").nil?       # too short -> nil
puts ZipcodeJa.find("").nil?          # empty -> nil
puts ZipcodeJa.find("abc1234").nil?   # non-digit -> nil
puts ZipcodeJa.find("12345678").nil?  # 8 digits -> nil
puts ZipcodeJa.find("0000000").nil?   # 7 digits but no matching file -> nil
