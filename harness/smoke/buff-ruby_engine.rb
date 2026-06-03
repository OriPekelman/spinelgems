require 'buff-ruby_engine'

# Test the module methods directly via Buff::RubyEngine
re = Buff::RubyEngine

# Under CRuby/MRI: mri? is true, jruby? and rubinius? are false
puts "mri?:      #{re.mri?}"
puts "jruby?:    #{re.jruby?}"
puts "rubinius?: #{re.rubinius?}"
puts "rbx?:      #{re.rbx?}"

# RUBY_ENGINE should be visible
puts "engine:    #{RUBY_ENGINE}"

# Exactly one of the three should be true for any known engine
flags = [re.mri?, re.jruby?, re.rubinius?]
puts "one_true:  #{flags.count(true) == 1}"

# The module mixes in via extend self — callable on the module directly
puts "module_respond_mri:    #{re.respond_to?(:mri?)}"
puts "module_respond_jruby:  #{re.respond_to?(:jruby?)}"
puts "module_respond_rbx:    #{re.respond_to?(:rbx?)}"
