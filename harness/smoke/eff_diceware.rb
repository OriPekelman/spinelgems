require 'eff_diceware'

# Smoke: exercise real wordlist parsing and lookup logic
# The generate() method uses SecureRandom so is non-deterministic;
# we test structural logic by reading the wordlist and doing lookups.

# 1. Verify version constant
puts "VERSION=#{EffDiceware::VERSION}"

# 2. Find the wordlist via the gem's own lib location
eff_rb = $LOAD_PATH.map { |p| File.join(p, "eff_diceware.rb") }.find { |f| File.exist?(f) }
gem_root = File.expand_path("../..", eff_rb)  # lib/eff_diceware.rb -> lib -> gem root
wordlist_path = File.join(gem_root, "eff_large_wordlist.txt")

lines = File.readlines(wordlist_path).map(&:chomp)

# 3. Look up specific known keys deterministically
keys = %w[11111 11112 66665 66666]
keys.each do |key|
  word = lines.grep(/^#{key}/)[0].split("\t")[1]
  puts "#{key}=#{word}"
end

# 4. Total wordlist size
puts "wordlist_size=#{lines.size}"

# 5. Verify roll returns value in 1..6 range (test many samples)
rolls = 20.times.map { EffDiceware.roll }
all_valid = rolls.all? { |r| r.is_a?(Integer) && r >= 1 && r <= 6 }
puts "roll_valid=#{all_valid}"
puts "roll_count=#{rolls.size}"

# 6. Verify key construction (5 dice rolls joined = 5-digit string from 1-6)
sample_key = rolls.first(5).join
puts "sample_key_length=#{sample_key.length}"
puts "sample_key_chars_valid=#{sample_key.chars.all? { |c| ('1'..'6').include?(c) }}"
