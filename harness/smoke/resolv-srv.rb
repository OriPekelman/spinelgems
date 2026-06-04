require 'resolv-srv'

# resolv-srv adds Resolv::DNS#each_srv_resource — an RFC-compliant SRV record
# iterator.  We exercise it without network by subclassing Resolv::DNS and
# stubbing #getresources to return hand-crafted SRV records.

# ── 1. Method is patched onto Resolv::DNS ────────────────────────────────────
puts Resolv::DNS.method_defined?(:each_srv_resource)   # => true

# ── 2. Argument validation ────────────────────────────────────────────────────
dns = Resolv::DNS.new

[
  [nil,         'tcp', 'example.com', "nil service"],
  ['',          'tcp', 'example.com', "empty service"],
  ['my.svc',   'tcp', 'example.com', "dotted service"],
  ['http',      nil,   'example.com', "nil protocol"],
  ['http',      '',    'example.com', "empty protocol"],
  ['http',      'x.y', 'example.com', "dotted protocol"],
].each do |svc, proto, dom, label|
  begin
    dns.each_srv_resource(svc, proto, dom) {}
    puts "#{label}: no error (unexpected)"
  rescue ArgumentError => e
    puts "#{label}: ArgumentError"
  end
end

# ── 3. Priority ordering via mock ─────────────────────────────────────────────
t1 = Resolv::DNS::Name.create('host1.example.com')
t2 = Resolv::DNS::Name.create('host2.example.com')
t3 = Resolv::DNS::Name.create('host3.example.com')

# Two records at priority 10, one at priority 20
srv_p10a = Resolv::DNS::Resource::IN::SRV.new(10, 100, 443, t1)
srv_p10b = Resolv::DNS::Resource::IN::SRV.new(10,  50, 443, t3)
srv_p20  = Resolv::DNS::Resource::IN::SRV.new(20, 100,  80, t2)

class MockDNS < Resolv::DNS
  def initialize(records)
    @records = records
  end
  def getresources(_name, _type)
    @records
  end
end

mock = MockDNS.new([srv_p20, srv_p10a, srv_p10b])

results = []
mock.each_srv_resource('https', 'tcp', 'example.com') do |r|
  results << r
end

puts results.length                     # => 3
puts results.last.priority              # => 20  (lowest priority always last)
puts results[0].priority               # => 10
puts results[1].priority               # => 10
# Both port 443 entries appear before port 80 entry
puts results.last.port                 # => 80

# ── 4. SRV fields accessible ─────────────────────────────────────────────────
puts srv_p10a.priority                 # => 10
puts srv_p10a.weight                   # => 100
puts srv_p10a.port                     # => 443
puts srv_p10a.target.to_s              # => host1.example.com

# ── 5. Weighted selection covers all available entries ────────────────────────
# Run many times; both priority-10 hosts must appear
srand(42)
seen = Hash.new(0)
100.times do
  MockDNS.new([srv_p10a, srv_p10b]).each_srv_resource('http', 'tcp', 'x.com') do |r|
    seen[r.target.to_s] += 1
  end
end
puts seen.keys.sort.length             # => 2  (both hosts seen)
puts seen.keys.sort.join(',')          # => host1.example.com,host3.example.com
