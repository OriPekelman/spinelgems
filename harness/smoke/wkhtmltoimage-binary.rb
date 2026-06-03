require 'wkhtmltoimage-binary'

# The gem's Ruby lib only provides a version constant and an empty module.
# It is a binary-distribution gem; all real behaviour lives in the
# platform-selected native executable under libexec/.

# 1. Constant exists and is a String
v = Wkhtmltoimage::Binary::VERSION
raise "VERSION not a String" unless v.is_a?(String)
raise "VERSION wrong" unless v == "0.12.5"
puts "VERSION: #{v}"

# 2. Module hierarchy is accessible
puts "module: #{Wkhtmltoimage::Binary}"
puts "ancestors: #{Wkhtmltoimage::Binary.ancestors.inspect}"

# 3. Module-level introspection (real logic exercised by Spinel's codegen)
puts "constants: #{Wkhtmltoimage::Binary.constants.sort.inspect}"
puts "ok"
