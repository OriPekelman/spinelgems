require 'magic_xml'

# 1. Build XML programmatically using the monadic interface
doc = XML.new(:catalog) do
  xml!(:book, {id: "1"}, "Ruby Programming")
  xml!(:book, {id: "2"}, "Spinel Gems")
  xml!(:book, {id: "3"}, "XML Processing")
end

puts doc.to_s

# 2. Parse XML from a string
xml_str = '<library><shelf name="A"><book id="10">Hello &amp; World</book><book id="11">Foo &lt;Bar&gt;</book></shelf><shelf name="B"><book id="20">Baz</book></shelf></library>'
root = XML.parse(xml_str)

puts root.name.inspect
puts root[:name].inspect  # nil — not an attribute of root

# 3. Access children and attributes
shelves = root.children(:shelf)
puts shelves.size
puts shelves.first[:name]

books = root.children(:shelf, :book)
puts books.size
puts books.map{|b| b[:id]}.join(",")
puts books.map{|b| b.text}.join("|")

# 4. descendants
all_books = root.descendants(:book)
puts all_books.size

# 5. String XML helpers
puts "Hello <World> & all".xml_escape
puts "&lt;foo&gt; &amp; bar".xml_unescape
puts "say \"hi\" & 'bye'".xml_attr_escape

# 6. XML.from_url with string: protocol (no network)
parsed = XML.from_url("string:<data><item key='x'>42</item></data>")
puts parsed.name
puts parsed.child(:item)[:key]
puts parsed.child(:item).text

# 7. case/=~ with symbol pattern
node = XML.new(:fruit, {color: "red"}, "apple")
puts(node =~ :fruit)
puts(node =~ :veggie)
puts(:fruit === node)
puts(:veggie === node)

# 8. All / Any matchers
fruit = XML.new(:fruit, {color: "red"})
puts All[:fruit, {color: "red"}] === fruit
puts All[:fruit, {color: "blue"}] === fruit
puts Any[:fruit, :veggie] === fruit

# 9. normalize! collapses adjacent text nodes
n = XML.new(:p)
n << "Hello, "
n << "world"
n << "!"
n.normalize!
puts n.contents.size
puts n.text

# 10. XML equality
a = XML.new(:foo, "Hello, ", "world")
b = XML.new(:foo, "Hello, world")
puts a == b
