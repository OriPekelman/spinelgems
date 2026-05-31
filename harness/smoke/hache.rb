puts Hache.h("Hello <World> & 'everyone' \"quoted\"")
puts Hache.h("no special chars")
puts Hache.h("a & b > c < d")
puts Hache.h("apostrophe ' and quote \"")
puts Hache::HTML_ESCAPE["&"]
puts Hache::HTML_ESCAPE["<"]
puts Hache::HTML_ESCAPE[">"]
