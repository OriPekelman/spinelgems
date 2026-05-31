# memcachier just copies MEMCACHIER_* env vars to MEMCACHE_* on require.
# No classes or methods are defined. Verify the require ran without error
# and that ENV is not disturbed when the source vars are absent.
puts ENV["MEMCACHE_SERVERS"].nil? || ENV["MEMCACHE_SERVERS"] == ENV["MEMCACHIER_SERVERS"]
puts ENV["MEMCACHE_USERNAME"].nil? || ENV["MEMCACHE_USERNAME"] == ENV["MEMCACHIER_USERNAME"]
puts ENV["MEMCACHE_PASSWORD"].nil? || ENV["MEMCACHE_PASSWORD"] == ENV["MEMCACHIER_PASSWORD"]
puts "loaded"
