require 'partystreusel'

# Partystreusel is a Rails engine with view helpers.
# We test the module structure and helper logic by stubbing the Rails/Haml deps.

# Stub symbolize_keys! on Hash (normally provided by ActiveSupport)
class Hash
  def symbolize_keys!
    keys.each do |key|
      self[key.to_sym] = delete(key) unless key.is_a?(Symbol)
    end
    self
  end
end

# Stub haml_tag to capture calls and record them
$haml_calls = []
module HamlCapture
  def haml_tag(tag, *args, &block)
    attrs = args.find { |a| a.is_a?(Hash) } || {}
    $haml_calls << { tag: tag, attrs: attrs }
    block.call if block
  end
end

# Test ReadmoreHelper
class ReadmoreTest
  include HamlCapture
  include Partystreusel::Helpers::ReadmoreHelper
end

obj = ReadmoreTest.new

# Test 1: basic readmore call (no extra attrs)
$haml_calls.clear
obj.readmore { }
call = $haml_calls.first
puts "readmore tag: #{call[:tag]}"
puts "readmore data-streusel: #{call[:attrs][:data]['streusel-readmore']}"

# Test 2: readmore with extra data attrs
$haml_calls.clear
obj.readmore({ 'data' => { 'foo' => 'bar' } }) { }
call = $haml_calls.first
puts "readmore with data-foo: #{call[:attrs][:data]['foo']}"
puts "readmore data-streusel present: #{call[:attrs][:data]['streusel-readmore']}"

# Test IconHelper module exists and has the method
puts "IconHelper method defined: #{Partystreusel::Helpers::IconHelper.method_defined?(:streusel_icon)}"

# Version
puts "VERSION: #{Partystreusel::VERSION}"
