# Smoke: Rviz::Helper (defined directly in rviz.rb, no external deps)
class TestHelper
  include Rviz::Helper
  def initialize
    @attrs = {"shape" => "box", "color" => "blue", "label" => "hello world"}
  end
end

h = TestHelper.new
puts h.quote("simple")
puts h.quote("hello world")
puts h.quote("ok")
puts h.attrs_to_s
