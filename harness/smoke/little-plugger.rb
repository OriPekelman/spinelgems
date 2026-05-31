# Test pure string utility methods — no gem loading, no filesystem
puts LittlePlugger::VERSION
puts LittlePlugger.underscore("FooBar")
puts LittlePlugger.underscore("FooBarBaz")
puts LittlePlugger.underscore("HTMLParser")
puts LittlePlugger.underscore("Foo::Bar")
puts LittlePlugger.default_plugin_path(String)
puts LittlePlugger.default_plugin_path(Array)
