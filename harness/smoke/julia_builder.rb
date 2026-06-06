require 'julia_builder'

# Simple struct to act as a data record
Person = Struct.new(:name, :age, :city)

# Basic builder: columns mapped by symbol (calls record.name, record.age, record.city)
class PersonCsv < Julia::Builder
  column :name
  column :age
  column :city
end

people = [
  Person.new('Alice', 30, 'Madrid'),
  Person.new('Bob',   25, 'Berlin'),
]

puts PersonCsv.build(people)

# Builder with a proc column (lambda) — runs in record context
class SalaryCsv < Julia::Builder
  column :name
  column 'monthly', -> { age * 100 }  # proc runs in record context
end

puts SalaryCsv.build(people)

# Builder with a block column — block receives record and host
class LabelCsv < Julia::Builder
  column :name
  column 'label' do |person|
    "#{person.name.upcase}-#{person.city}"
  end
end

puts LabelCsv.build(people)

# Verify version constant is accessible
puts Julia::VERSION
