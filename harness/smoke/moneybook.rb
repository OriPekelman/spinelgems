# moneybook is a CLI-only gem; lib/moneybook.rb is a stub:
#   "### mock file .. use moneybook executable instead"
# require 'moneybook' loads nothing — no constants, no classes, no methods.
# The real implementation lives in bin/moneybook and depends on
# terminal-table, andand, highline, and iconv (external, unavailable).
# There is no public Ruby API to exercise.

require 'moneybook'

puts defined?(Moneybook).inspect          # => nil
puts defined?(REGEXP_COMP_LINE).inspect   # => nil
puts "moneybook loaded (stub only)"
