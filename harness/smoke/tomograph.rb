require 'tomograph'

# Exercise Tomograph::Path — path normalization and matching
p1 = Tomograph::Path.new('/users/{id}/posts')
puts p1.to_s
puts p1.match('/users/42/posts').nil? ? 'no-match' : 'match'
puts p1.match('/users/42/posts/extra').nil? ? 'no-match' : 'match'

p2 = Tomograph::Path.new('/search{?q,page}')
puts p2.to_s

p3 = Tomograph::Path.new('/items/{id}{&filter}')
puts p3.to_s

p4 = Tomograph::Path.new('/trailing/')
puts p4.to_s

p5 = Tomograph::Path.new('/fixed')
puts p5.to_s
puts p5.match('/fixed').nil? ? 'no-match' : 'match'
puts p5.match('/other').nil? ? 'no-match' : 'match'

p6 = Tomograph::Path.new('')
puts p6.to_s.inspect

# Path equality
p7 = Tomograph::Path.new('/users/{id}/posts')
puts(p1 == p7 ? 'equal' : 'not-equal')

# Exercise Tomograph::Tomogram::Action — wraps path + metadata
action = Tomograph::Tomogram::Action.new(
  path:         '/api/v1/users/{id}',
  method:       'GET',
  content_type: 'application/json',
  requests:     [],
  responses:    [{ 'status' => '200', 'body' => {}, 'content-type' => 'application/json' }],
  resource:     'Users'
)
puts action.method
puts action.path.to_s
puts action.content_type
puts action.resource
puts action.find_responses(status: 200).length
puts action.find_responses(status: 404).length

# to_hash round-trip
h = action.to_hash
puts h['method']
puts h['resource']
