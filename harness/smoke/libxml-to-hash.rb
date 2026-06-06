# libxml-to-hash smoke
#
# This gem wraps libxml-ruby (xml/libxml) — a C-extension gem — to provide
# Hash.from_libxml(xml_string). The C extension is not available in the verify
# sandbox, so lib/xml/libxml.rb in the gem cache is a minimal pure-Ruby stub
# (defines an empty XML module) that lets the gem load. Hash.from_libxml is
# NOT exercised because it requires XML::Parser at runtime.
#
# Under Spinel, plain `require 'xml/libxml'` is ignored (cross-gem require),
# but the pure-Ruby classes (LibXmlNode, iterable extensions) are compiled
# normally. The smoke targets those classes exclusively.

require 'libxml_to_hash'

# --- LibXmlNode API ---

# 1. Node with attributes only → simplify returns self (has attrs, not reducible)
n = LibXmlNode.new
n.add_attribute("lang", "en")
n.add_node("title", "Hello World")
puts n.attributes.inspect         # {"lang"=>"en"}
puts n.subnodes.inspect           # {"title"=>"Hello World"}
puts n.simplify.class             # LibXmlNode

# 2. Node with only subnodes → simplify returns the subnodes hash
n2 = LibXmlNode.new
n2.add_node("country", "France")
n2.add_node("city", "Paris")
puts n2.simplify.inspect          # {"country"=>"France", "city"=>"Paris"}

# 3. Node with only text → simplify returns the string
n3 = LibXmlNode.new
n3.add_text("hello")
n3.add_text(" world")
puts n3.simplify.inspect          # "hello world"

# 4. Empty node → simplify returns the empty subnodes hash
n4 = LibXmlNode.new
puts n4.simplify.inspect          # {}

# 5. Repeated child keys → coerced into Array (mirrors repeated XML elements)
n5 = LibXmlNode.new
n5.add_node("item", "alpha")
n5.add_node("item", "beta")
n5.add_node("item", "gamma")
puts n5.subnodes["item"].inspect  # ["alpha", "beta", "gamma"]

# 6. LibXmlNode.create factory
created = LibXmlNode.create({"k" => "v"}, {"attr" => "1"}, "txt")
puts created.subnodes.inspect     # {"k"=>"v"}
puts created.attributes.inspect   # {"attr"=>"1"}
puts created.text                 # txt

# 7. Equality
a = LibXmlNode.create({}, {}, "same")
b = LibXmlNode.create({}, {}, "same")
c = LibXmlNode.create({}, {}, "diff")
puts a == b   # true
puts a == c   # false

# 8. iterable extensions on core classes
puts "string".iterable.inspect    # ["string"]
puts [10, 20].iterable.inspect    # [10, 20]
puts({foo: "bar"}.iterable.inspect) # [{foo: "bar"}]
n6 = LibXmlNode.new
puts n6.iterable.length           # 1
