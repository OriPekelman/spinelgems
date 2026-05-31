# ruby_dig smoke: exercise RubyDig module on a custom hash-like class
class MyMap
  include RubyDig
  def initialize(h); @h = h; end
  def [](k); @h[k]; end
end

m = MyMap.new({a: MyMap.new({b: 42}), c: "hello", d: nil})
puts m.dig(:a, :b)
puts m.dig(:c)
puts m.dig(:missing).inspect
puts m.dig(:d).inspect
puts m.dig(:a, :b).class
