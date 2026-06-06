# frozen_string_literal: true

require "barcodevalidation"

# Test 1: valid EAN-13 barcode (0-padded UPC-A)
gtin13 = BarcodeValidation.scan("4006381333931")
puts gtin13.valid?        # true
puts gtin13.to_s          # 4006381333931
puts gtin13.class.name    # BarcodeValidation::GTIN::GTIN13

# Test 2: valid UPC-A (12-digit)
upc = BarcodeValidation.scan("036000291452")
puts upc.valid?           # true
puts upc.to_s             # 036000291452
puts upc.class.name       # BarcodeValidation::GTIN::GTIN12

# Test 3: invalid barcode — bad check digit
bad = BarcodeValidation.scan("4006381333932")
puts bad.valid?           # false
puts bad.class.name       # BarcodeValidation::InvalidGTIN

# Test 4: all-zeros is invalid
zeros = BarcodeValidation.scan("0000000000000")
puts zeros.valid?         # false

# Test 5: transcode GTIN-12 to GTIN-13
gtin13_from_upc = upc.to_gtin_13
puts gtin13_from_upc.valid?   # true
puts gtin13_from_upc.to_s     # 0036000291452

# Test 6: scan! raises on invalid input
begin
  BarcodeValidation.scan!("1234567890000")
  puts "no error"
rescue BarcodeValidation::InvalidGTINError => e
  puts "InvalidGTINError raised"
end

# Test 7: check_digit valid/invalid on a real GTIN-8
gtin8 = BarcodeValidation.scan("96385074")
puts gtin8.valid?         # true
puts gtin8.class.name     # BarcodeValidation::GTIN::GTIN8

# Test 8: strip whitespace/hyphens via sanitize
spaced = BarcodeValidation.scan("4006381-333931")
puts spaced.valid?        # true
puts spaced.to_s          # 4006381333931
