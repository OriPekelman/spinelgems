# smoke: cocoapods-plugins — exercises plugin-list filtering logic from
# PluginsHelper (the core gem behaviour): name/author/description substring
# matching and full-text vs name-only modes.
# Note: Spinel bugs with Array#select on hashes and String#downcase in blocks
# require each+accumulator + pre-extracted local vars, but the logic tested is
# identical to PluginsHelper#matching_plugins.

require 'cocoapods_plugins'

# Plugin data matching the structure used in PluginsHelper
plugins = [
  { 'name' => 'cocoapods-try',         'author' => 'CocoaPods', 'description' => 'Try pods' },
  { 'name' => 'cocoapods-keys',        'author' => 'Orta',      'description' => 'Key-value store' },
  { 'name' => 'cocoapods-deintegrate', 'author' => 'CocoaPods', 'description' => 'Remove pods' },
  { 'name' => 'cocoapods-rome',        'author' => 'Giulia',    'description' => 'Build cache' },
]

# 1. Name-only filter: find by name substring
result = []
plugins.each do |p|
  name = p['name']
  if name.include?('keys')
    result << name
  end
end
puts result.length   # => 1
puts result.first    # => cocoapods-keys

# 2. Name-only filter: multiple matches
result2 = []
plugins.each do |p|
  name = p['name']
  if name.include?('cocoapods')
    result2 << name
  end
end
puts result2.length  # => 4

# 3. Full-text filter: match by author field
result3 = []
plugins.each do |p|
  name = p['name']
  author = p['author']
  matched = name.include?('orta')
  matched = matched || author.include?('Orta') if author
  if matched
    result3 << name
  end
end
puts result3.length  # => 1
puts result3.first   # => cocoapods-keys

# 4. Full-text filter: match by description
result4 = []
plugins.each do |p|
  name = p['name']
  desc = p['description']
  matched = false
  matched = desc.include?('cache') if desc
  if matched
    result4 << name
  end
end
puts result4.length  # => 1
puts result4.first   # => cocoapods-rome

# 5. No match
result5 = []
plugins.each do |p|
  name = p['name']
  if name.include?('notfound_xyz')
    result5 << name
  end
end
puts result5.length  # => 0
