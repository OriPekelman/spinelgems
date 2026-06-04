require 'xmlcanonicalizer'

# Exercise XML::Util::XmlCanonicalizer — the C14N implementation
# Uses REXML documents; no network, no filesystem, no external gems.

include REXML

# --- Test 1: simple element canonicalization ---
xml1 = '<root><child attr="b" aaa="a">text</child></root>'
doc1 = Document.new(xml1)
c1 = XML::Util::XmlCanonicalizer.new(false, true)
result1 = c1.canonicalize(doc1)
puts "T1: #{result1}"

# --- Test 2: namespace handling ---
xml2 = '<ns:root xmlns:ns="http://example.com"><ns:child>hello</ns:child></ns:root>'
doc2 = Document.new(xml2)
c2 = XML::Util::XmlCanonicalizer.new(false, true)
result2 = c2.canonicalize(doc2)
puts "T2: #{result2}"

# --- Test 3: multiple attributes sorted alphabetically ---
xml3 = '<elem z="last" a="first" m="middle"/>'
doc3 = Document.new(xml3)
c3 = XML::Util::XmlCanonicalizer.new(false, true)
result3 = c3.canonicalize(doc3)
puts "T3: #{result3}"

# --- Test 4: white_text? helper via direct instantiation ---
c4 = XML::Util::XmlCanonicalizer.new(true, false)
puts "T4 white empty: #{c4.send(:white_text?, '   ')}"
puts "T4 white text:  #{c4.send(:white_text?, 'hello')}"

# --- Test 5: remove_whitespace helper ---
c5 = XML::Util::XmlCanonicalizer.new(false, false)
ws_in  = '<a> <b> </b> </a>'
ws_out = c5.send(:remove_whitespace, ws_in)
puts "T5: #{ws_out}"

# --- Test 6: NamespaceNode accessors ---
nn = XML::Util::NamespaceNode.new('xmlns:foo', 'http://foo.example/')
puts "T6 prefix: #{nn.prefix}"
puts "T6 uri:    #{nn.uri}"
