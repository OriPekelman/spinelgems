# Smoke for XMLCanonicalizer 1.0.1
# Exercises XML::Util::XmlCanonicalizer (C14N) and XML::Util::NamespaceNode.
# The top-level xmlcanonicalizer.rb requires log4r (unavailable); we load the
# inner implementation file which has those requires commented out.
require 'rexml/document'

# In the harness, the gem's lib/ is on LOAD_PATH (ruby -Ilib) and Spinel
# inlines require_relative from the gem root. The inner file has log4r
# requires commented out, so it loads cleanly without the external dep.
require 'xml/util/xmlcanonicalizer'
include REXML

# --- NamespaceNode: prefix/uri accessors ---
nn = XML::Util::NamespaceNode.new('xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/')
puts nn.prefix
puts nn.uri

# --- XmlCanonicalizer: canonicalize simple element tree ---
xml = '<root><child>hello</child><sibling>world</sibling></root>'
doc = Document.new(xml)
c = XML::Util::XmlCanonicalizer.new(false, true)
result = c.canonicalize(doc)
puts result
puts result.length

# --- canonicalize with nested structure ---
xml2 = '<envelope><body><item>42</item></body></envelope>'
doc2 = Document.new(xml2)
c2 = XML::Util::XmlCanonicalizer.new(false, true)
puts c2.canonicalize(doc2)

# --- canonicalize with whitespace content ---
xml3 = '<a><b>  </b><c>text</c></a>'
doc3 = Document.new(xml3)
c3 = XML::Util::XmlCanonicalizer.new(false, true)
result3 = c3.canonicalize(doc3)
puts result3
