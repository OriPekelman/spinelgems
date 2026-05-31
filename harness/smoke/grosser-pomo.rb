require_relative "lib/pomo/translation"
# Exercise Pomo::Translation pure logic (no file I/O, no external deps)
t = Pomo::Translation.new
t.msgid = "hello"
t.msgstr = "bonjour"
puts t.complete?
puts t.plural?
puts t.fuzzy?

t2 = Pomo::Translation.new
t2.msgid = "world"
t2.msgstr = "monde"
puts t2.complete?
puts t2.plural?

t3 = Pomo::Translation.new
t3.msgid = ["item", "items"]
t3.msgstr = ["objet", "objets"]
puts t3.plural?
puts t3.complete?
