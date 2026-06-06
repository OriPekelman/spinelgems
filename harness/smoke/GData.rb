# Smoke: GData gem — Google Data API client (legacy, 2007-era)
# Exercises: GData::Spreadsheet#entry (XML generation), attribute readers from GData::Base

# Stub unavailable external gems so CRuby can load this gem.
# Under Spinel, plain `require` to other gems is silently ignored anyway.
$LOADED_FEATURES << 'hpricot' unless $LOADED_FEATURES.include?('hpricot')
$LOADED_FEATURES << 'builder'  unless $LOADED_FEATURES.include?('builder')
module Hpricot; end unless defined?(Hpricot)
module Builder;
  class XmlMarkup; end
end unless defined?(Builder)

# Pre-declare GData as a module so that gdata/base.rb can reopen it.
# (The top-level gdata.rb declares it as a class, causing a TypeError when
# gdata/base.rb tries to reopen it as a module. The bin scripts bypass this
# by requiring gdata/spreadsheet or gdata/blogger directly.)
module GData
  VERSION = '0.0.4'
end unless defined?(GData) && GData.is_a?(Module) && !GData.is_a?(Class)

require 'gdata/base'
require 'gdata/spreadsheet'

# --- GData::Spreadsheet attribute readers (from GData::Base) ---
gs = GData::Spreadsheet.new('spreadsheet_abc123')
puts gs.service   # => wise
puts gs.source    # => gdata-ruby
puts gs.url       # => spreadsheets.google.com

# --- GData::Spreadsheet#entry generates an Atom+GS XML fragment ---
# Default row=1, col=1
xml1 = gs.entry('SQRT(16)', 1, 1)
puts xml1.include?("xmlns:gs='http://schemas.google.com/spreadsheets/2006'")  # => true
puts xml1.include?("inputValue='=SQRT(16)'")  # => true
puts xml1.include?("row='1'")                 # => true
puts xml1.include?("col='1'")                 # => true

# Custom row/col
xml2 = gs.entry('SUM(B2:B10)', 4, 2)
puts xml2.include?("inputValue='=SUM(B2:B10)'")  # => true
puts xml2.include?("row='4'")                     # => true
puts xml2.include?("col='2'")                     # => true

# --- @headers nil => public path in evaluate_cell (test the path string logic) ---
# We can't call the network, but the path computation logic uses @headers truthiness.
# Construct what the path would be (no-auth => 'public')
expected_path_fragment = gs.instance_variable_get(:@headers) ? "private" : "public"
puts expected_path_fragment  # => public
