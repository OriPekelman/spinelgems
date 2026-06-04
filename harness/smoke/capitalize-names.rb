require 'capitalize_names'

# Basic full name capitalization
puts CapitalizeNames.capitalize("john smith")
puts CapitalizeNames.capitalize("MARY JANE WATSON")
puts CapitalizeNames.capitalize("james MCDONALD")

# Scottish Mc/Mac prefix handling
puts CapitalizeNames.capitalize("angus mcdonald", format: :lastname)
puts CapitalizeNames.capitalize("fiona macgregor", format: :lastname)

# Dutch/French prefixes (van, de, de la)
puts CapitalizeNames.capitalize("hendrik van beethoven")
puts CapitalizeNames.capitalize("charles de gaulle")

# O'apostrophe handling
puts CapitalizeNames.capitalize("brian o'brien", format: :lastname)

# Givenname-only format (no surname rules)
puts CapitalizeNames.capitalize("mary-jane", format: :firstname)

# capitalize! raises on nil; capitalize returns original on error
begin
  CapitalizeNames.capitalize!(nil)
rescue CapitalizeNames::Errors::InvalidName => e
  puts "InvalidName: #{e.message}"
end

# capitalize (non-bang) returns original name on error
puts CapitalizeNames.capitalize(nil).inspect
