# frozen_string_literal: true
# Smoke: actionpack-xml_parser 2.0.1
#
# This gem is a thin Rails plugin. Its main lib file (action_pack/xml_parser.rb)
# hard-requires active_support and action_dispatch at the top level. Those gems
# are not available in the isolated smoke environment, so --full mode (which
# loads all lib files) fails under CRuby with LoadError before the smoke body runs.
#
# The only loadable surface without Rails is:
#   lib/actionpack-xml_parser.rb  — conditional require (no-op without Rails)
#   lib/action_pack/xml_parser/version.rb — the VERSION constant

puts ActionPack::XmlParser::VERSION
puts ActionPack::XmlParser.is_a?(Class)
