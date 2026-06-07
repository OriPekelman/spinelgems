# githelp smoke
# The githelp gem's lib/ exposes only GitHelp::VERSION and an empty GitHelp module.
# All real logic lives in exe/githelp and depends on the 're_expand' and 'scrapbox'
# gems (not available in this environment) plus network access to scrapbox.io.
# This smoke exercises the version constant — the only smokeable surface in lib/.

require 'githelp'

puts GitHelp::VERSION
puts GitHelp.is_a?(Module)
puts GitHelp.name
