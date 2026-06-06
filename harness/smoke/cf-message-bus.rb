require 'cf_message_bus'
require 'cf_message_bus/mock_message_bus'

# Exercise MockMessageBus: pub/sub, stringify_keys, request/respond, synchronous requests

bus = CfMessageBus::MockMessageBus.new

# 1. subscribe and publish — verify message delivery and stringify_keys
received = []
bus.subscribe('test.subject') { |msg| received << msg }
bus.publish('test.subject', { foo: 'bar', nested: { num: 42 } })

puts received.length          # => 1
puts received[0]['foo']       # => bar
puts received[0]['nested'].class  # => Hash
puts received[0]['nested']['num'] # => 42

# 2. published_messages tracking
puts bus.published_messages.length  # => 1
puts bus.has_published?('test.subject') ? 'found' : 'not found'  # => found
puts bus.has_published_with_message?('test.subject', { foo: 'bar', nested: { num: 42 } }) ? 'match' : 'no match'  # => match

# 3. request / respond_to_request
response_data = nil
bus.request('query.subject', { id: 1 }) { |data| response_data = data }
bus.respond_to_request('query.subject', { result: 'ok', code: 200 })
puts response_data['result']  # => ok
puts response_data['code']    # => 200

# 4. synchronous request / respond
bus.respond_to_synchronous_request('sync.subject', { status: 'alive' })
result = bus.synchronous_request('sync.subject', nil)
puts result['status']         # => alive
puts bus.has_requested_synchronous_messages?('sync.subject') ? 'tracked' : 'missing'  # => tracked

# 5. connected? and reset
puts bus.connected?           # => true
bus.reset
puts bus.published_messages.length  # => 1 (published_messages not cleared by reset)
bus.clear_published_messages
puts bus.published_messages.length  # => 0

# 6. CfMessageBus.mock! / make_message_bus
CfMessageBus.mock!
mocked = CfMessageBus.make_message_bus
puts mocked.class             # => CfMessageBus::MockMessageBus
puts mocked.connected?        # => true
CfMessageBus.unmock!
