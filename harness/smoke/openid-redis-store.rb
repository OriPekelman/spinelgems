# frozen_string_literal: true

# Smoke for openid-redis-store 0.0.2
# OpenID::Store::Redis — a Redis-backed OpenID association store.
# It requires ruby-openid (openid/store/interface, openid/store/nonce,
# openid/util) which are not available system-wide.  We stub the minimum
# needed for the self-contained logic to load and exercise.

# --- Stubs for ruby-openid deps ---

module OpenID
  module Util
    def self.log(msg); end
  end

  module Store
    class Interface
      def store_association(server_url, assoc); raise NotImplementedError; end
      def get_association(server_url, handle = nil); raise NotImplementedError; end
      def remove_association(server_url, handle); raise NotImplementedError; end
      def use_nonce(server_url, timestamp, salt); raise NotImplementedError; end
      def cleanup_nonces; end
      def cleanup_associations; end
      def cleanup; end
    end

    module Nonce
      SKEW = 300  # 5 minutes, same as ruby-openid default
      def self.skew; SKEW; end
    end
  end
end

# Prevent rubygems from trying to load the real gems
%w[openid/util openid/store/interface openid/store/nonce time].each do |f|
  $LOADED_FEATURES.push(f) unless $LOADED_FEATURES.include?(f)
end

require 'open_id/store/redis'

# ------------------------------------------------------------------
# 1. assoc_key: pure string composition logic
# ------------------------------------------------------------------
# We need a minimal Redis client stub (no network) and a minimal
# association stub for the tests that need them.

class FakeRedis
  def initialize; @store = {}; @ttls = {}; end

  def setex(key, ttl, value)
    @store[key] = value
    @ttls[key]  = ttl
    'OK'
  end

  def get(key)
    @store[key]
  end

  def setnx(key, value)
    return false if @store.key?(key)
    @store[key] = value
    true
  end

  def expire(key, ttl)
    @ttls[key] = ttl
    true
  end

  def del(key)
    existed = @store.key?(key)
    @store.delete(key)
    @ttls.delete(key)
    existed ? 1 : 0
  end

  def ttl_for(key); @ttls[key]; end
  def raw(key);     @store[key]; end
end

# Minimal association stub that responds to .handle, .lifetime, Marshal round-trip
class FakeAssoc
  attr_reader :handle, :lifetime
  def initialize(handle, lifetime)
    @handle   = handle
    @lifetime = lifetime
  end
  def ==(other)
    other.is_a?(FakeAssoc) && handle == other.handle && lifetime == other.lifetime
  end
end

store = OpenID::Store::Redis.new(FakeRedis.new, 'test:')

# 1. assoc_key — no handle
puts store.assoc_key('https://provider.example.com/')
# => test:Ahttps://provider.example.com/

# 2. assoc_key — with handle
puts store.assoc_key('https://provider.example.com/', 'my-handle-123')
# => test:Ahttps://provider.example.com/|my-handle-123

# 3. key_prefix accessor
puts store.key_prefix
# => test:

# 4. store_association + get_association round-trip via Marshal
redis  = FakeRedis.new
store2 = OpenID::Store::Redis.new(redis, 'pfx:')
assoc  = FakeAssoc.new('hdl-42', 3600)
store2.store_association('https://op.test/', assoc)

# Check the key was stored under the expected Redis key
expected_key = 'pfx:Ahttps://op.test/|hdl-42'
raw = redis.raw(expected_key)
puts raw.nil? ? 'missing' : 'stored'
# => stored

# TTL should equal association.lifetime
puts redis.ttl_for(expected_key)
# => 3600

# get_association deserialises correctly
got = store2.get_association('https://op.test/', 'hdl-42')
puts got.handle
# => hdl-42
puts got.lifetime
# => 3600

# 5. use_nonce — fresh nonce accepted
redis3  = FakeRedis.new
store3  = OpenID::Store::Redis.new(redis3, 'n:')
now_ts  = Time.now.to_i
result  = store3.use_nonce('https://op.test/', now_ts, 'abc123')
puts result
# => true

# 6. use_nonce — same nonce a second time is rejected
result2 = store3.use_nonce('https://op.test/', now_ts, 'abc123')
puts result2
# => false

# 7. use_nonce — timestamp too old is rejected
old_ts  = Time.now.to_i - OpenID::Store::Nonce::SKEW - 10
result3 = store3.use_nonce('https://op.test/', old_ts, 'xyz789')
puts result3
# => false

# 8. cleanup methods are no-ops (return nil)
puts store.cleanup_nonces.nil?       # => true
puts store.cleanup.nil?              # => true
puts store.cleanup_associations.nil? # => true
