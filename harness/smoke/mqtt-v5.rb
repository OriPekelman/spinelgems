# Smoke: mqtt-v5 gem — TopicAlias subsystem (self-contained, no mqtt/core needed)
# Exercises Cache bidirectional mapping, LRU policy aliasability, and LengthWeightedPolicy.
# Note: the full packet API requires mqtt/core (external dep); only TopicAlias is reachable here.

require 'set'

# Cache: bidirectional alias<->topic mapping
cache = MQTT::V5::TopicAlias::Cache.new(max: 4)
puts cache.max
puts cache.size
puts cache.full?

cache.add(1, 'home/living/temperature')
cache.add(2, 'home/living/humidity')
cache.add(3, 'home/bedroom/light')

puts cache.resolve(1)
puts cache.resolve('home/living/humidity')
puts cache.size
puts cache.full?

cache.remove('home/living/temperature')
puts cache.size
puts cache.topics.sort.inspect

# LRU policy
lru = MQTT::V5::TopicAlias::LRUPolicy.new
puts lru.aliasable?(nil)
lru.alias_hit('a/b')
lru.alias_hit('c/d')

# Length-weighted policy
lwp = MQTT::V5::TopicAlias::LengthWeightedPolicy.new
puts lwp.aliasable?(nil)

# Manager with send_maximum=0 (disabled)
mgr = MQTT::V5::TopicAlias::Manager.new(send_maximum: 0)
puts mgr.outgoing.nil?

# Manager with active aliasing
mgr2 = MQTT::V5::TopicAlias::Manager.new(send_maximum: 10)
puts mgr2.outgoing.nil?
puts mgr2.policy.is_a?(MQTT::V5::TopicAlias::LRUPolicy)
