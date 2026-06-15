# The gem's entry file is lib/travis_formatter.rb (not matching the gem name)
# and requires XCPretty::Simple from xcpretty gem. Stub it first, then load.
module XCPretty
  class Simple
    def initialize(use_unicode, colorize)
    end
  end
end

require_relative "lib/travis_formatter"

# format_group is a pure string-transformation method — no external deps
tf = TravisFormatter.new(false, false)

puts tf.format_group("MyProject")
puts tf.format_group("MyProject")
puts tf.format_group("build.3")
puts tf.format_group("Hello World! 123")
puts tf.format_group("trailing-")
