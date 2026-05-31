# SingleTest: CMD_LINE_MATCHER constant — pure regexp matching, no Rake needed
puts("spec:user_controller:blah" =~ SingleTest::CMD_LINE_MATCHER ? "match" : "no match")
puts("test:orders" =~ SingleTest::CMD_LINE_MATCHER ? "match" : "no match")
puts("random:other" =~ SingleTest::CMD_LINE_MATCHER ? "match" : "no match")
puts("spec:" =~ SingleTest::CMD_LINE_MATCHER ? "match" : "no match")
puts("test:foo:bar" =~ SingleTest::CMD_LINE_MATCHER ? "match" : "no match")
