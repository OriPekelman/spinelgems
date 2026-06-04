require 'dot-properties'

# 1. Parse a .properties string and read values
src = <<~PROPS
  # a comment
  name = Alice
  greeting = Hello, ${name}!
  port: 8080
  empty_key =
PROPS

props = DotProperties.parse(src)

puts props['name']
puts props['port']
puts props['greeting']        # variable expansion: Hello, Alice!
puts props['empty_key'].inspect

# 2. set + get
props.set('color', 'blue')
puts props['color']

# 3. delete
props.delete('port')
puts props.has_key?('port').inspect

# 4. to_h round-trip — keys present
h = props.to_h
puts h.key?('name').inspect
puts h.key?('color').inspect

# 5. to_s / to_a serialisation
props2 = DotProperties.parse(props.to_s)
puts props2['name']
puts props2['color']

# 6. keys / size
props.compact!
puts props.size
puts props.keys.sort.inspect
