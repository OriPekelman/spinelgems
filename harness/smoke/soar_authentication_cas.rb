env = { 'CAS_SERVER' => 'https://cas.example.com', 'RACK_ENV' => 'production' }
servers = SoarAuthenticationCas.cas_servers(env)
puts servers['production']
puts servers['development']

env2 = { 'CAS_SERVER' => 'https://cas.dev.example.com', 'RACK_ENV' => 'development' }
servers2 = SoarAuthenticationCas.cas_servers(env2)
puts servers2['production']
puts servers2['development']

puts SoarAuthenticationCas.configure(nil).inspect
