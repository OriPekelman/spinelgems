class Person
  include FromHash
  attr_accessor :name, :age

  def initialize(hash = {})
    @name = nil
    @age = nil
    from_hash(hash)
  end
end

p = Person.new(name: "Alice", age: 30)
puts p.name
puts p.age

p2 = Person.new
p2.from_hash(name: "Bob", age: 25)
puts p2.name
puts p2.age

p3 = Person.new
puts p3.name.nil?
puts p3.age.nil?
