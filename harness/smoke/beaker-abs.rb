# Smoke test for beaker-abs 1.1.0
# Tests: BeakerAbs::Version, Beaker::Abs#generate_floaty_request_strings,
#         Beaker::Abs#connection_preference, Beaker::Abs#cleanup
#
# beaker-abs/abs.rb requires 'beaker', 'vmfloaty', 'vmfloaty/conf', 'vmfloaty/utils'
# at the top level. We stub those before requiring so we can exercise the pure logic.

# ---- Stubs for unavailable runtime deps ----
module Beaker
  class Hypervisor
    def initialize(hosts, options); end
    def self.respond_to?(m, *args); false; end
    def connection_preference(_host)
      [:name]
    end
  end

  class Host
    attr_reader :name, :host_hash
    def initialize(name, template)
      @name = name
      @host_hash = {}
      @template = template
    end
    def [](key)
      case key
      when :template, 'template' then @template
      when :vmhostname            then @vmhostname
      when :hypervisor            then 'abs'
      end
    end
    def []=(key, val)
      case key
      when :vmhostname, 'vmhostname' then @vmhostname = val
      when :ip, 'ip'                 then @ip = val
      end
    end
    def hostname; @name; end
  end
end

module Conf
  def self.read_config; {}; end
end
module Utils; end

# Mark vmfloaty and beaker as already-loaded so require no-ops
$LOADED_FEATURES << 'beaker.rb'         unless $LOADED_FEATURES.include?('beaker.rb')
$LOADED_FEATURES << 'vmfloaty.rb'       unless $LOADED_FEATURES.include?('vmfloaty.rb')
$LOADED_FEATURES << 'vmfloaty/conf.rb'  unless $LOADED_FEATURES.include?('vmfloaty/conf.rb')
$LOADED_FEATURES << 'vmfloaty/utils.rb' unless $LOADED_FEATURES.include?('vmfloaty/utils.rb')

# ---- Load the gem ----
require 'beaker-abs'
require 'beaker/hypervisor/abs'

# ---- 1. Version ----
puts "version=#{BeakerAbs::Version::STRING}"

# ---- 2. generate_floaty_request_strings ----
# Build a minimal Abs instance via new with provision:false and an empty resource list
abs = Beaker::Abs.new([], { provision: false, abs_resource_hosts: '[]' })

supported = ['centos-7-x86_64', 'redhat-7-x86_64', 'ubuntu-18.04-x86_64']

hosts_a = [
  Beaker::Host.new('host1', 'centos-7-x86_64'),
  Beaker::Host.new('host2', 'centos-7-x86_64'),
  Beaker::Host.new('host3', 'redhat-7-x86_64'),
]

result = abs.generate_floaty_request_strings(hosts_a, supported)
# result is "centos-7-x86_64=2 redhat-7-x86_64=1 " (order is insertion order in Ruby >= 1.9)
pairs = result.strip.split(' ').sort
puts "floaty_request=#{pairs.join(',')}"

# Single host
hosts_b = [Beaker::Host.new('solo', 'ubuntu-18.04-x86_64')]
result_b = abs.generate_floaty_request_strings(hosts_b, supported)
puts "floaty_single=#{result_b.strip}"

# ---- 3. generate_floaty_request_strings raises on unknown template ----
begin
  hosts_bad = [Beaker::Host.new('unknown', 'no-such-os')]
  abs.generate_floaty_request_strings(hosts_bad, supported)
  puts "no_raise=unexpected"
rescue ArgumentError => e
  puts "raises_on_unknown=true"
end

# ---- 4. connection_preference: non-abs host falls through to super ----
# We set up @resource_hosts so we can test the 'abs + vmpooler' path
abs.instance_variable_set(:@resource_hosts, [
  { 'hostname' => 'pool1.example.com', 'engine' => 'vmpooler' },
  { 'hostname' => 'ns1.example.com',   'engine' => 'nspooler' },
  { 'hostname' => 'aws1.example.com',  'engine' => 'aws' },
])

# host with vmhostname + vmpooler → returns [:vmhostname]
vmpooler_host = Object.new
def vmpooler_host.[](k)
  case k
  when :vmhostname then 'pool1.example.com'
  when :hypervisor then 'abs'
  end
end
pref_vmpooler = abs.connection_preference(vmpooler_host)
puts "vmpooler_pref=#{pref_vmpooler.inspect}"

# host with vmhostname + nspooler → returns [:vmhostname]
nspooler_host = Object.new
def nspooler_host.[](k)
  case k
  when :vmhostname then 'ns1.example.com'
  when :hypervisor then 'abs'
  end
end
pref_nspooler = abs.connection_preference(nspooler_host)
puts "nspooler_pref=#{pref_nspooler.inspect}"

# host with no vmhostname → falls through to Hypervisor#connection_preference → [:name]
plain_host = Object.new
def plain_host.[](k)
  case k
  when :vmhostname then nil
  when :hypervisor then 'abs'
  end
end
pref_plain = abs.connection_preference(plain_host)
puts "plain_pref=#{pref_plain.inspect}"

# ---- 5. cleanup is a no-op ----
abs.cleanup
puts "cleanup=ok"
