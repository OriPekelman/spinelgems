# smoke: net-telnet-rfc2217
# RFC 2217 serial-port-over-telnet extension without a live connection.
# Exercises: modem-param validation, attribute assignment, and telnet preprocess
# (the IAC escape processor patched into Net::Telnet via TelnetExtensions).

require 'net-telnet-rfc2217'

# -- 1. RFC2217 class exists
puts Net::Telnet::RFC2217.class

# -- 2. set_modem_params raises ArgumentError on invalid parity
obj = Net::Telnet::RFC2217.allocate
begin
  obj.send(:set_modem_params, parity: :bogus)
  puts "no error"
rescue ArgumentError => e
  puts e.message
end

# -- 3. set_modem_params stores serial attributes (no socket needed when @telnet is nil)
obj2 = Net::Telnet::RFC2217.allocate
obj2.send(:set_modem_params, baud: 9600, data_bits: 7, parity: :odd, stop_bits: 2)
puts obj2.baud
puts obj2.data_bits
puts obj2.parity
puts obj2.stop_bits

# -- 4. TelnetExtensions is prepended into Net::Telnet
puts Net::Telnet.ancestors.first.name

# -- 5. preprocess: plain string passes through unchanged (Binmode=true)
tn = Net::Telnet.allocate
tn.instance_variable_set(:@options, {'Telnetmode' => false, 'Binmode' => true})
tn.instance_variable_set(:@telnet_option, {})
puts tn.send(:preprocess, 'hello')

# -- 6. preprocess: IAC IAC (escaped IAC) collapses to single IAC byte (255)
IAC = Net::Telnet::IAC
result = tn.send(:preprocess, IAC + IAC)
puts result.bytes.first
