class Person
  include AttrRequired
  attr_required :name, :email
end

p = Person.new
puts p.attr_required?(:name)
puts p.attr_required?(:email)
puts p.attr_required?(:age)
puts p.required_attributes.sort.inspect
puts p.attr_missing?
p.name = "Alice"
puts p.attr_missing.inspect
p.email = "alice@example.com"
puts p.attr_missing?
begin
  p2 = Person.new
  p2.attr_missing!
rescue AttrRequired::AttrMissing => e
  puts e.message
end
