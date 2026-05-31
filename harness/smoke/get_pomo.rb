# Smoke: GetPomo Translation and PoFile.parse - no external deps
t = GetPomo::Translation.new
t.msgid = "hello"
t.msgstr = "bonjour"
puts t.complete?
puts t.header?
puts t.plural?
puts t.fuzzy?

po_text = <<~PO
  # comment
  msgid "world"
  msgstr "monde"
PO

translations = GetPomo::PoFile.parse(po_text)
puts translations.size
puts translations.first.msgid
puts translations.first.msgstr
