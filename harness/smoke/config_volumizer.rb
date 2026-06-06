require 'config_volumizer'

# --- parse: simple scalar value ---
env = {
  'DATABASE_URL' => 'postgres://localhost/mydb',
  'DATABASE_POOL' => '5',
}
mapping = { 'DATABASE_URL' => :value, 'DATABASE_POOL' => :value }
result = ConfigVolumizer.parse(env, mapping)
puts result['DATABASE_URL']
puts result['DATABASE_POOL']

# --- parse: flat hash (dynamic sub-keys) ---
env2 = {
  'REDIS_HOST' => 'localhost',
  'REDIS_PORT' => '6379',
  'REDIS_DB'   => '0',
}
result2 = ConfigVolumizer.parse(env2, 'REDIS' => :hash)
puts result2['REDIS'].sort.map { |k, v| "#{k}=#{v}" }.join(',')

# --- parse: nested hash mapping ---
env3 = {
  'APP_DB_HOST' => 'db.example.com',
  'APP_DB_PORT' => '5432',
}
result3 = ConfigVolumizer.parse(env3, 'APP' => { 'DB' => { 'HOST' => :value, 'PORT' => :value } })
puts result3['APP']['DB']['HOST']
puts result3['APP']['DB']['PORT']

# --- fetch: single key with default ---
env4 = { 'TIMEOUT' => '30' }
val = ConfigVolumizer.fetch(env4, 'TIMEOUT', :value)
puts val

missing = ConfigVolumizer.fetch({}, 'MISSING', :value, 'default_val')
puts missing

# --- generate: round-trip a structured config ---
data = {
  'server' => { 'host' => 'localhost', 'port' => 8080 },
  'flags'  => [true, false],
}
generated = ConfigVolumizer.generate(data)
env_out = generated.env_hash
map_out = generated.mapping_hash
puts env_out.sort.map { |k, v| "#{k}:#{v}" }.join(',')
puts map_out['server'].inspect
puts map_out['flags'].inspect
