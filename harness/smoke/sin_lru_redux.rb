# frozen_string_literal: true

require 'sin_lru_redux'

# Basic LRU cache: capacity=3
cache = SinLruRedux::Cache.new(3)

cache[:a] = 1
cache[:b] = 2
cache[:c] = 3

# Access :a to make it most-recently-used
puts cache[:a]          # => 1

# Insert :d — evicts :b (least recently used)
cache[:d] = 4
puts cache.key?(:b)     # => false (evicted)
puts cache.key?(:d)     # => true

# count
puts cache.count        # => 3

# getset: fetch or compute — evicts :c (LRU after :a promoted, :d inserted)
val = cache.getset(:e) { 99 }
puts val                # => 99
# :c was LRU, evicted; :a still present
puts cache.key?(:a)     # => true

# delete / evict
cache.delete(:e)
puts cache.count        # => 2

# to_a returns pairs most-recent first
cache2 = SinLruRedux::Cache.new(3)
cache2[:x] = 10
cache2[:y] = 20
cache2[:z] = 30
pairs = cache2.to_a
puts pairs.map { |k, v| "#{k}=#{v}" }.join(',')  # => z=30,y=20,x=10

# Resize: shrink to 1, only most-recent survives
cache2.max_size = 1
puts cache2.count       # => 1
puts cache2.key?(:z)    # => true
puts cache2.key?(:x)    # => false

# fetch with block (miss)
result = cache2.fetch(:missing) { :default }
puts result             # => default

# VERSION is a string
puts SinLruRedux::VERSION.is_a?(String)  # => true
