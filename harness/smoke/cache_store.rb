# frozen_string_literal: true
require 'cache_store'

# Exercise LocalCacheStore: set/get/exist?/remove

store = LocalCacheStore.new('test')

# Basic set and get
store.set('greeting', 'hello')
puts store.get('greeting')          # hello

# exist? positive
puts store.exist?('greeting')       # true

# get with block (cache miss)
result = store.get('missing') { 'fallback' }
puts result                          # fallback
# block value is now cached
puts store.get('missing')           # fallback

# remove and confirm gone
store.remove('greeting')
puts store.exist?('greeting')       # false
puts store.get('greeting').inspect  # nil

# Numeric value
store.set('counter', 42)
puts store.get('counter')           # 42

# expire immediately (0 means no expiry, use 1 second in the past via set then force expire)
# Instead demonstrate non-expiry: expires_in = 0 means no expiry
store.set('permanent', 'stays', 0)
puts store.exist?('permanent')      # true
