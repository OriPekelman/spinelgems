require 'securerandom'

# sysrandom/securerandom just replaces SecureRandom with Sysrandom (a native ext).
# Pre-mark these as loaded so CRuby does not try to load the native sysrandom_ext;
# under Spinel the require is silently ignored and stdlib SecureRandom is used.
$LOADED_FEATURES << 'sysrandom.rb'          unless $LOADED_FEATURES.include?('sysrandom.rb')
$LOADED_FEATURES << 'sysrandom/securerandom.rb' unless $LOADED_FEATURES.include?('sysrandom/securerandom.rb')

require 'pwqgen.rb'
require 'pwqgen/version'

# Version constant
puts Pwqgen::VERSION

# Deterministic rand stub so output is reproducible across Ruby / Spinel
module DeterministicRand
  SEQUENCE = [10, 1, 5, 2, 100, 3, 7, 1, 4, 200, 0, 3]
  @idx = 0

  def self.random_number(n)
    val = SEQUENCE[@idx % SEQUENCE.length] % n
    @idx += 1
    val
  end
end

# Exercise Generator: 3-word password with default separators
gen = Pwqgen::Generator.new
gen.instance_variable_set(:@rand, DeterministicRand)
pwd = gen.generate(3)
puts pwd
puts pwd.length > 5 ? "ok-length" : "bad-length"
puts pwd =~ /[a-zA-Z]/ ? "ok-alpha" : "bad-alpha"

# Verify module-level method exists
puts Pwqgen.respond_to?(:generate) ? "ok-module-generate" : "bad-module-generate"

# Exercise Generator with 2 words and a custom single separator
DeterministicRand.instance_variable_set(:@idx, 0)
gen2 = Pwqgen::Generator.new("~")
gen2.instance_variable_set(:@rand, DeterministicRand)
pwd2 = gen2.generate(2)
puts pwd2
puts pwd2.include?("~") ? "ok-separator" : "no-separator"
