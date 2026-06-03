# smoke: simple_po_parser — exercises parse_message with real PO message types
require 'simple_po_parser'

# 1. Simple singular message
msg1 = SimplePoParser.parse_message(
  "msgid \"Hello\"\nmsgstr \"Bonjour\""
)
puts msg1[:msgid]
puts msg1[:msgstr]

# 2. Message with translator comment, extracted comment, and reference
msg2 = SimplePoParser.parse_message(
  "# translator note\n" \
  "#. extracted note\n" \
  "#: src/main.rb:42\n" \
  "msgid \"Save\"\n" \
  "msgstr \"Enregistrer\""
)
puts msg2[:translator_comment]
puts msg2[:extracted_comment]
puts msg2[:reference]
puts msg2[:msgid]
puts msg2[:msgstr]

# 3. Message with msgctxt (disambiguation context)
msg3 = SimplePoParser.parse_message(
  "msgctxt \"menu\"\n" \
  "msgid \"File\"\n" \
  "msgstr \"Fichier\""
)
puts msg3[:msgctxt]
puts msg3[:msgid]
puts msg3[:msgstr]

# 4. Plural message
msg4 = SimplePoParser.parse_message(
  "msgid \"%d item\"\n" \
  "msgid_plural \"%d items\"\n" \
  "msgstr[0] \"%d element\"\n" \
  "msgstr[1] \"%d elements\""
)
puts msg4[:msgid]
puts msg4[:msgid_plural]
puts msg4["msgstr[0]"]
puts msg4["msgstr[1]"]

# 5. Flag (fuzzy)
msg5 = SimplePoParser.parse_message(
  "#, fuzzy\n" \
  "msgid \"Quit\"\n" \
  "msgstr \"Quitter\""
)
puts msg5[:flag]
puts msg5[:msgid]

puts "done"
