puts Passw.lowercase.first(5).join
puts Passw.uppercase.first(5).join
puts Passw.numbers.join
puts Passw.symbols.length
puts Passw.calculate_entropy(72, 12).to_s
puts Passw.password_strength(25)
puts Passw.password_strength(30)
puts Passw.password_strength(50)
puts Passw.password_strength(80)
puts Passw.password_strength(200)
