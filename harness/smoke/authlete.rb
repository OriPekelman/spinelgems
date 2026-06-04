require 'authlete'

# 1. Authlete::Model::Pair - simple key/value model with Hashable
pair = Authlete::Model::Pair.new(key: 'grant_type', value: 'authorization_code')
puts pair.key
puts pair.value
h = pair.to_hash
puts h[:key]
puts h[:value]

# 2. Authlete::Model::Property - key/value/hidden model; test defaults and override
prop_default = Authlete::Model::Property.new(key: 'sub', value: 'user123')
puts prop_default.key
puts prop_default.value
puts prop_default.hidden.inspect   # should be false

prop_hidden = Authlete::Model::Property.new(key: 'internal_id', value: 'x99', hidden: true)
puts prop_hidden.hidden.inspect    # should be true

# 3. Authlete::Model::NamedUri - name + uri model
nu = Authlete::Model::NamedUri.new(name: 'homepage', uri: 'https://example.com')
puts nu.name
puts nu.uri
nu_hash = nu.to_hash
puts nu_hash[:name]
puts nu_hash[:uri]

# 4. Authlete::Model::TaggedValue - tag + value (used in Scope descriptions)
tv = Authlete::Model::TaggedValue.new(tag: 'en', value: 'Read access to profile')
puts tv.tag
puts tv.value
tv_hash = tv.to_hash
puts tv_hash[:tag]
puts tv_hash[:value]

# 5. Authlete::Model::Scope with nested TaggedValue descriptions and Pair attributes
scope = Authlete::Model::Scope.new(
  name: 'profile',
  defaultEntry: true,
  description: 'Access to profile',
  descriptions: [
    { tag: 'en', value: 'Access to profile' },
    { tag: 'fr', value: 'Accès au profil' }
  ],
  attributes: [
    { key: 'display', value: 'Profile' }
  ]
)
puts scope.name
puts scope.default_entry.inspect
puts scope.description
puts scope.descriptions.length
puts scope.descriptions.first.tag
puts scope.descriptions.last.value
puts scope.attributes.first.key

# 6. Base.parse with Hash vs non-Hash
parsed_pair = Authlete::Model::Pair.parse({ key: 'scope', value: 'openid' })
puts parsed_pair.key
puts Authlete::Model::Pair.parse(nil).inspect   # should be nil

# 7. Authlete::Model::Pair round-trip via string-keyed hash (normalize_hash_key)
pair2 = Authlete::Model::Pair.new('key' => 'response_type', 'value' => 'code')
puts pair2.key
puts pair2.value
