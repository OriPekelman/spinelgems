require 'foto'
require 'date'

# VERSION constant
puts Foto::VERSION

# Config module: defaults and options
Foto::Config.reset!
puts Foto::Config.api_key
puts Foto::Config.base_uri

Foto.configure do |c|
  c.api_key = 'test-key-' + '42'
  c.base_uri = 'https://example.com'
end
puts Foto::Config.api_key
puts Foto::Config.base_uri
opts = Foto::Config.options
puts opts[:api_key]
puts opts[:base_uri]

# Reset back to defaults
Foto::Config.reset!
puts Foto::Config.api_key

# JsonDate: pure date-to-JSON-string conversion
d = Date.new(2020, 6, 15)
# Convert to Time for strftime and to_i
t = Time.utc(d.year, d.month, d.day)
jd = Foto::JsonDate.new(t)
puts jd.to_json

# Patient: attributes and class methods
puts Foto::Patient.url
puts Foto::Patient.attributes.sort.inspect

p = Foto::Patient.new(
  first_name: 'Alice',
  last_name:  'Smith',
  email:      'alice@example.com',
  gender:     'F',
  language:   'en'
)
puts p.first_name
puts p.last_name
puts p.email
puts p.gender
puts p.language
