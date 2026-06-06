require 'greeklish_iso843'

# Exercise GreeklishIso843::GreekText.to_greeklish (class method)
# and the instance method via new(...).to_greeklish

# Basic single words
puts GreeklishIso843::GreekText.to_greeklish('αλφα')       # => alfa
puts GreeklishIso843::GreekText.to_greeklish('θεσσαλονίκη') # => thessaloniki
puts GreeklishIso843::GreekText.to_greeklish('Ελλάδα')      # => Ellada

# Digraph pairs: αυ/ευ -> af/av/ef/ev depending on next char
puts GreeklishIso843::GreekText.to_greeklish('αυτός')       # => aftos
puts GreeklishIso843::GreekText.to_greeklish('αύριο')       # => avrio? (ρ is vowel-like)

# μπ at word-start = 'b', in middle between vowels = 'mp'
puts GreeklishIso843::GreekText.to_greeklish('μπαλκόνι')    # => balkoni
puts GreeklishIso843::GreekText.to_greeklish('κάμπος')      # => kampos

# Instance method
gt = GreeklishIso843::GreekText.new('χαίρετε')
puts gt.to_greeklish                                        # => chairete
puts gt.text                                                # => χαίρετε (original preserved)

# Mixed case / uppercase letters
puts GreeklishIso843::GreekText.to_greeklish('ΑΘΗΝΑ')       # => ATHINA
puts GreeklishIso843::GreekText.to_greeklish('Ψυχή')        # => Psychi
