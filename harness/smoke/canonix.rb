require 'xmlcanonicalizer'

# Test 1: Simple attribute canonicalization (self-close -> expanded, attrs sorted)
xml1 = "<foo z='last' a='first'/>"
doc1 = REXML::Document.new(xml1)
c1 = XML::Util::XmlCanonicalizer.new(true, true)
result1 = c1.canonicalize(doc1)
puts result1

# Test 2: Namespace handling - namespace should appear on element
xml2 = "<root xmlns:ns='http://example.com'><ns:child/></root>"
doc2 = REXML::Document.new(xml2)
c2 = XML::Util::XmlCanonicalizer.new(false, true)
result2 = c2.canonicalize(doc2)
puts result2

# Test 3: Same canonicalizer, multiple documents (state reset check)
c3 = XML::Util::XmlCanonicalizer.new(true, true)
xml3a = "<b x='1'/>"
xml3b = "<b x='2'/>"
doc3a = REXML::Document.new(xml3a)
doc3b = REXML::Document.new(xml3b)
r3a = c3.canonicalize(doc3a)
r3b = c3.canonicalize(doc3b)
puts r3a
puts r3b

# Test 4: Element node via REXML::XPath (canonicalize just a sub-element)
xml4 = "<root><child attr='val'>text content</child></root>"
doc4 = REXML::Document.new(xml4)
elem4 = REXML::XPath.first(doc4, "//child")
c4 = XML::Util::XmlCanonicalizer.new(true, true)
result4 = c4.canonicalize(elem4)
puts result4

# Test 5: NamespaceNode helper class
nn = XML::Util::NamespaceNode.new("xmlns:ds", "http://www.w3.org/2000/09/xmldsig#")
puts nn.prefix
puts nn.uri

# Test 6: white_text? behaviour via a document with whitespace-only text nodes
xml6 = "<root>  \t  <item>hello</item>  </root>"
doc6 = REXML::Document.new(xml6)
c6 = XML::Util::XmlCanonicalizer.new(true, true)
result6 = c6.canonicalize(doc6)
puts result6
