require 'pil'

# Pil: Password Inclusion List — checks against 10,000 most common passwords

# Class-level API
puts Pil.include?('password')          # => true  (very common)
puts Pil.include?('qwerty')            # => true  (very common)
puts Pil.include?('xK9!mZq2#rLp')     # => false (not in list)
puts Pil.exclude?('dragon')            # => false (it IS common)
puts Pil.exclude?('xK9!mZq2#rLp')     # => true  (not common)

# Instance-level API
pil = Pil.new
puts pil.include?('123456')            # => true
puts pil.include?('football')          # => true
puts pil.exclude?('correct-horse-battery-staple')  # => true (not in list)

# PasswordList directly
pl = Pil::PasswordList.new
puts pl.count                          # => 10000
puts pl.include?('baseball')           # => true
puts pl.exclude?('baseball')           # => false
