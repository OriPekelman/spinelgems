# Wavedash: Japanese encoding character normalization
# Drive the constant and normalize/invalid? API deterministically

puts Wavedash::CHARACTER_CODE_MAPPING.keys.sort.join(",")

Wavedash.destination_encoding = 'eucjp-ms'
wave = "\u{301C}"
tilde = "\u{FF5E}"
puts Wavedash.normalize(wave)
puts Wavedash.invalid?(wave)
puts Wavedash.invalid?("hello")

Wavedash.destination_encoding = 'euc-jp'
puts Wavedash.normalize(tilde)
puts Wavedash.invalid?(tilde)
puts Wavedash.invalid?("abc")
