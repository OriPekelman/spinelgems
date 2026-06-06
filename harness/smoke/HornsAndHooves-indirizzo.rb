require 'indirizzo'

# Parse a standard US address
a = Indirizzo::Address.new("1600 Pennsylvania Ave NW, Washington, DC 20500")
puts a.number
puts a.state
puts a.zip
puts a.street.first
puts a.city.first

# Parse an address with a building type suffix
b = Indirizzo::Address.new("350 Fifth Avenue, New York, NY 10118")
puts b.number
puts b.state
puts b.zip

# Test po_box? on a regular address (should be false)
puts a.po_box?.inspect

# Test intersection? on a regular address (should be false)
puts a.intersection?.inspect

# Test Map lookup
puts Indirizzo::State["California"]
puts Indirizzo::State["TX"]
puts Indirizzo::Directional["North"]
puts Indirizzo::Suffix_Type["Street"]
