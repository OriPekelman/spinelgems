# Exercise AeNetworkConnectionException without network or external deps
puts AeNetworkConnectionException::ConnectionNotEstablished.superclass
e = AeNetworkConnectionException::ConnectionNotEstablished.new("test error")
puts e.message
puts e.class
