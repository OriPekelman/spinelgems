# ruby-watchr: code smell data model
# Avoid require 'watchr' (top-level) — it pulls in flay which is not available.
# Load only the self-contained sub-files.
require 'watchr/version'
require 'watchr/smell_types'
require 'watchr/smell'
require 'watchr/location'
require 'watchr/smell_builder'

# VERSION
puts "VERSION: #{Watchr::VERSION}"

# SmellTypes::ALL_SMELLS constant
smells = Watchr::SmellTypes::ALL_SMELLS
puts "smell count: #{smells.size}"
puts "first smell: #{smells.first}"
puts "includes :long_method: #{smells.include?(:long_method)}"

# Watchr::Smell — constructor and readers
smell = Watchr::Smell.new(:long_method, 'MyClass#my_method', 'Method is too long')
puts "smell type: #{smell.type}"
puts "smell context: #{smell.context}"
puts "smell description: #{smell.description}"
puts "locations empty: #{smell.locations.empty?}"

# Watchr::Location — constructor and readers
loc = Watchr::Location.new('app/models/user.rb', 42)
puts "location file: #{loc.file}"
puts "location line: #{loc.line}"

# Location.from_path class method
loc2 = Watchr::Location.from_path('lib/foo.rb:17')
puts "from_path file: #{loc2.file}"
puts "from_path line: #{loc2.line}"

# add_location accumulates on Smell
smell.add_location(loc)
smell.add_location(loc2)
puts "locations count: #{smell.locations.size}"
puts "first location file: #{smell.locations.first.file}"
puts "first location line: #{smell.locations.first.line}"

# SmellBuilder — valid type builds and adds location + details
builder = Watchr::SmellBuilder.new(:nested_iterators, 'SomeClass#do_stuff', 'Too many nested iterators')
builder.add_location('lib/some_class.rb', 10)
builder.add_details('Nesting level: 3')
puts "builder smell type: #{builder.smell.type}"
puts "builder smell details: #{builder.smell.details}"
puts "builder location count: #{builder.smell.locations.size}"

# SmellBuilder — invalid type raises RuntimeError
begin
  Watchr::SmellBuilder.new(:not_a_real_smell, 'Ctx', 'desc')
  puts "no error raised"
rescue RuntimeError => e
  puts "invalid smell error: #{e.message.include?('Invalid smell type') ? 'yes' : 'no'}"
end
