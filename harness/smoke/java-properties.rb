# Smoke: java-properties — parse and generate round-trip

props_text = "name=Alice\nage=30\ncity=Wonderland"
props = JavaProperties.parse(props_text)

# Print sorted key=value pairs for determinism
props.keys.map(&:to_s).sort.each do |k|
  puts "#{k}=#{props[k.to_sym]}"
end

# Generate back and parse again
generated = JavaProperties.generate(props)
props2 = JavaProperties.parse(generated)

puts props2[:name]
puts props2[:age]
puts props2[:city]

# Version constant
puts JavaProperties::VERSION
