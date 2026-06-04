require 'capybara-select-2'

# Exercise CapybaraSelect2::VERSION
puts "version=#{CapybaraSelect2::VERSION}"

# Exercise Utils.set_option_aliases — merges :label into :from if :from missing
opts1 = { label: "My Label", css: ".sel" }
aliased = CapybaraSelect2::Utils.set_option_aliases(opts1)
puts "set_option_aliases from=#{aliased[:from]}"

opts2 = { from: "Existing", label: "Ignored", css: ".sel" }
aliased2 = CapybaraSelect2::Utils.set_option_aliases(opts2)
puts "set_option_aliases preserves from=#{aliased2[:from]}"

# Exercise Utils.validate_options! — should not raise for valid options
[:css, :xpath, :from].each do |key|
  begin
    CapybaraSelect2::Utils.validate_options!({ key => "val" })
    puts "validate_options! ok for :#{key}"
  rescue => e
    puts "validate_options! raised for :#{key}: #{e.message}"
  end
end

begin
  CapybaraSelect2::Utils.validate_options!({})
  puts "validate_options! should have raised"
rescue ArgumentError => e
  puts "validate_options! raised ArgumentError: #{e.message}"
end

# Exercise Utils.detect_select2_version via a duck-typed container
class FakeContainer
  def initialize(cls, id)
    @cls = cls
    @id = id
  end
  def [](attr)
    case attr
    when 'class' then @cls
    when 'id' then @id
    end
  end
end

v4_container = FakeContainer.new("select2 select2-container", "some-id")
v3_container = FakeContainer.new("s2id_something", "s2id_select")
v2_container = FakeContainer.new("my-widget", "my-id")

puts "detect_version v4=#{CapybaraSelect2::Utils.detect_select2_version(v4_container)}"
puts "detect_version v3=#{CapybaraSelect2::Utils.detect_select2_version(v3_container)}"
puts "detect_version v2=#{CapybaraSelect2::Utils.detect_select2_version(v2_container)}"

# Exercise Selectors module_function methods
['2', '3', '4'].each do |ver|
  puts "opener[#{ver}]=#{CapybaraSelect2::Selectors.opener_selector(ver)}"
  puts "search_input[#{ver}]=#{CapybaraSelect2::Selectors.search_input_selector(ver)}"
  puts "option[#{ver}]=#{CapybaraSelect2::Selectors.option_selector(ver)}"
  puts "remove[#{ver}]=#{CapybaraSelect2::Selectors.remove_option_selector(ver)}"
end
