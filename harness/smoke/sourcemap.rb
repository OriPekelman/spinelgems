require 'sourcemap'

# Exercise SourceMap::VLQ encode/decode
encoded = SourceMap::VLQ.encode([0, 0, 0, 0])
puts "VLQ encode [0,0,0,0]: #{encoded}"

decoded = SourceMap::VLQ.decode(encoded)
puts "VLQ decode back: #{decoded.inspect}"

encoded2 = SourceMap::VLQ.encode([1, -1, 5, 3])
puts "VLQ encode [1,-1,5,3]: #{encoded2}"

decoded2 = SourceMap::VLQ.decode(encoded2)
puts "VLQ decode back: #{decoded2.inspect}"

# encode_mappings / decode_mappings round-trip
mappings_in = [[0, 0, 0, 0], [1, 0, 2, 3]]
vlq_str = SourceMap::VLQ.encode_mappings([mappings_in])
puts "encode_mappings: #{vlq_str}"

decoded_mappings = SourceMap::VLQ.decode_mappings(vlq_str)
puts "decode_mappings: #{decoded_mappings.inspect}"

# Exercise SourceMap::Offset
o1 = SourceMap::Offset.new(3, 10)
o2 = SourceMap::Offset.new(1, 5)
puts "Offset to_s: #{o1}"
puts "Offset + Offset: #{(o1 + o2)}"
puts "Offset compare: #{(o1 <=> o2)}"

# Exercise SourceMap::Mapping
gen  = SourceMap::Offset.new(1, 0)
orig = SourceMap::Offset.new(5, 4)
m = SourceMap::Mapping.new('app.js', gen, orig, 'foo')
puts "Mapping to_s: #{m}"

# Build a Map from_hash (exercises Map + VLQ decode + Offset + Mapping)
hash = {
  'version'  => 3,
  'file'     => 'out.js',
  'sources'  => ['a.js'],
  'names'    => [],
  'mappings' => 'AAAA'
}
map = SourceMap::Map.from_hash(hash)
puts "Map size: #{map.size}"
puts "Map sources: #{map.sources.inspect}"
puts "Map[0] to_s: #{map[0]}"

# Round-trip: to_s -> encode_mappings string
puts "Map VLQ string: #{map.to_s}"
