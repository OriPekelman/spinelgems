h = HashKit::Helper.new

# symbolize: string keys -> symbol keys
sym = h.symbolize({ "a" => 1, "b" => 2, "c" => "hello" })
puts sym[:a]
puts sym[:b]
puts sym[:c]

# stringify: symbol keys -> string keys
str = h.stringify({ a: 10, b: 20, c: "world" })
puts str["a"]
puts str["b"]
puts str["c"]

# nested symbolize
nested = h.symbolize({ "x" => { "y" => 99 } })
puts nested[:x][:y]

# to_hash with a plain object
class SampleObj
  def initialize
    @name = "alice"
    @age = 30
  end
end
result = h.to_hash(SampleObj.new)
puts result[:name]
puts result[:age]
