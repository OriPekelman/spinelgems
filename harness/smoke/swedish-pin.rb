# frozen_string_literal: true
# Smoke test for swedish-pin gem — validates, parses, and formats Swedish PINs.
require 'swedish-pin'

# Use a fixed reference time to get deterministic output
NOW = Time.new(2026, 1, 1, 0, 0, 0)

# --- valid? ---
puts SwedishPIN.valid?("8507099805", NOW)   # true — known-valid PIN
puts SwedishPIN.valid?("000101-0000", NOW)  # false — bad checksum
puts SwedishPIN.valid?("not-a-pin", NOW)    # false

# --- parse + Personnummer attributes ---
pin = SwedishPIN.parse("8507099805", NOW)
puts pin.year          # 1985
puts pin.month         # 7
puts pin.day           # 9
puts pin.sequence_number  # 980
puts pin.control_digit    # 5
puts pin.female?       # false (odd sequence_number)
puts pin.male?         # true
puts pin.coordination_number?  # false

# --- format_long / format_short with fixed now ---
puts pin.format_long         # 19850709-9805
puts pin.format_short(NOW)   # 850709-9805

# --- age with fixed now ---
puts pin.age(NOW)   # 40 (birthday Jul 9 1985; Jan 1 2026 = 40)

# --- birthday ---
puts pin.birthday   # 1985-07-09

# --- luhn helper (public API) ---
puts SwedishPIN.luhn("850709980")  # 5

# --- coordination number (day+60 input) ---
# 850769-1270: born 1985-07-09 but stored as day=69 (9+60) — valid coord number
coord = SwedishPIN.parse("850769-1270", NOW)
puts coord.coordination_number?  # true
puts coord.day                   # 9 (real day, coord stripped)
puts coord.format_long           # 19850769-1270 (day+60 preserved in output)

# --- another valid PIN with "+" separator (100+ years old) ---
pin2 = SwedishPIN.parse("121212+1212", NOW)
puts pin2.year   # 1912
puts pin2.format_long  # 19121212-1212
