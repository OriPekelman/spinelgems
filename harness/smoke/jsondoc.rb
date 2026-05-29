schema = {
  type: 'object',
  properties: {
    id:   { default: '', description: 'Doc Id', type: 'string' },
    name: { default: 'anon', description: 'Name', type: 'string' }
  }
}

doc = JsonDoc::Document.new({id: 'abc', name: 'Alice'}, schema)
puts doc.getProp(:id)
puts doc.getProp(:name)
puts doc.getProp('id')

doc2 = JsonDoc::Document.new(nil, schema, true)
puts doc2.getProp(:id)
puts doc2.getProp(:name)

puts doc.validateKey(:id)
puts doc.bIsStrict

doc.setProp(:name, 'Bob')
puts doc.getProp(:name)

puts doc.getValStringForProperties([:id, :name], ',')
puts doc.getDescStringForProperties([:id, :name], ',')
