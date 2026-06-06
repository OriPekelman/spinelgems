# smoke: funky-emv
# This gem is an mruby-based EMV POS terminal library (CloudWalk/PAX).
# Its entire Ruby implementation lives in out/funky-emv/main.mrb (compiled mruby
# bytecode). The only Ruby source in lib/ is version.rb — there is no lib/funky-emv.rb
# entrypoint. All EMV classes (EmvTransaction, EmvPax, EmvSharedLibrary) are defined
# in the mruby binary and are not accessible from standard MRI Ruby.
# We load version.rb via require (harness uses -Ilib), which is all that can be loaded.

require 'version'

puts FunkyEmv::VERSION
puts FunkyEmv::VERSION.class
parts = FunkyEmv::VERSION.split('.').map(&:to_i)
puts parts.inspect
puts parts.length == 3
puts parts.all? { |p| p >= 0 }
