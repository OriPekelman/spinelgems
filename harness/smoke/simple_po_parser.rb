# smoke: simple_po_parser
# Tests VERSION constant and parse_message with a simple PO string

puts SimplePoParser::VERSION

msg = SimplePoParser.parse_message(
  "msgid \"Hello\"\nmsgstr \"Hallo\""
)
puts msg[:msgid]
puts msg[:msgstr]

msg2 = SimplePoParser.parse_message(
  "# Translator comment\nmsgid \"World\"\nmsgstr \"Welt\""
)
puts msg2[:translator_comment]
puts msg2[:msgid]
puts msg2[:msgstr]
