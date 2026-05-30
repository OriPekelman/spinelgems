# smoke: mini_memory_store
store = MiniMemoryStore.new(expires_in: 9999999)

# set and get
store.set("hello")
puts store.get

# cache: miss then hit
result = store.cache { "computed" }
puts result
puts store.get

# set again
store.set(42)
puts store.get

# clear
store.clear
puts store.get.nil?

# cache returns existing value without re-computing
store.set("cached")
out = store.cache { "should_not_compute" }
puts out
