uuid = Identifier.generate
puts uuid.length
puts uuid.count('-')
parts = uuid.split('-')
puts parts.length
puts parts.map(&:length).inspect
# version nibble should be 4 (UUID v4)
puts uuid[14]
# variant bits: position 19 should be 8, 9, a, or b
puts ['8','9','a','b'].include?(uuid[19]) ? "variant-ok" : "variant-bad"
