require 'vat-siren-siret'

# Validate known-good SIREN (Luhn-valid 9-digit number)
# 732829320 is a known valid SIREN (France Telecom)
siren = '732829320'
puts "siren?(#{siren}) = #{Vss.siren?(siren)}"

# Invalid SIREN
bad_siren = '123456789'
puts "siren?(#{bad_siren}) = #{Vss.siren?(bad_siren)}"

# SIRET: SIREN + 5-digit NIC, Luhn-valid. Use a known one.
# 73282932000074 is a known valid SIRET
siret = '73282932000074'
puts "siret?(#{siret}) = #{Vss.siret?(siret)}"

# Format a valid SIREN
fmt = Vss.format_siren(siren)
puts "format_siren(#{siren}) = #{fmt}"

# Format a valid SIRET
fmt2 = Vss.format_siret(siret)
puts "format_siret(#{siret}) = #{fmt2}"

# Convert SIREN to VAT
vat = Vss.to_vat(siren)
puts "to_vat(#{siren}) = #{vat}"

# Validate the generated VAT
puts "vat?(#{vat}) = #{Vss.vat?(vat)}"

# Format VAT
fmt3 = Vss.format_vat(vat)
puts "format_vat(#{vat}) = #{fmt3}"

# Round-trip: VAT -> SIREN
siren2 = Vss.to_siren(vat)
puts "to_siren(#{vat}) = #{siren2}"
puts "round_trip_ok = #{siren2 == siren}"

# Non-string inputs return false/nil, not raise
puts "siren?(nil) = #{Vss.siren?(nil)}"
puts "siren?(123) = #{Vss.siren?(123)}"
