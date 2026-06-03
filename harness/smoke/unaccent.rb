# frozen_string_literal: true

require 'unaccent'

# Exercise Unaccent.unaccent with real accented inputs

# French accents
puts Unaccent.unaccent('café')
puts Unaccent.unaccent('naïve')
puts Unaccent.unaccent('façade')

# German / Nordic
puts Unaccent.unaccent('über')
puts Unaccent.unaccent('Åland')

# ASCII passthrough (no-op path)
puts Unaccent.unaccent('hello')

# Mixed accented and plain
result = Unaccent.unaccent('résumé and naïve')
puts result

# String with no accents returns same value
plain = 'world'
puts Unaccent.unaccent(plain) == plain
