# frozen_string_literal: true

require 'mini_cache'

cache = MiniCache::Store.new

# set + get
cache.set('name', 'Alice')
puts cache.get('name')         # Alice

# set? (present / absent)
puts cache.set?('name')        # true
puts cache.set?('missing')     # false

# get_or_set — first call sets, second returns cached
cache.get_or_set('score') { 42 }
puts cache.get('score')        # 42
cache.get_or_set('score') { 99 }
puts cache.get('score')        # 42  (unchanged)

# symbol key
cache.set(:lang, 'Ruby')
puts cache.get(:lang)          # Ruby

# unset removes the key
cache.set('tmp', 'bye')
cache.unset('tmp')
puts cache.set?('tmp')         # false

# reset clears all
cache.set('a', 1)
cache.set('b', 2)
cache.reset
puts cache.data.size           # 0

# load via constructor
cache2 = MiniCache::Store.new('x' => 10, 'y' => 20)
puts cache2.get('x')           # 10
puts cache2.get('y')           # 20

# each enumeration (sorted for determinism)
cache2.each { |k, v| puts "#{k}=#{v.value}" }  # x=10, y=20

# Data equality
d1 = MiniCache::Data.new('hello')
d2 = MiniCache::Data.new('hello')
puts d1 == d2                  # true
