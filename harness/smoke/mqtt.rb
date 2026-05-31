puts MQTT::DEFAULT_PORT
puts MQTT::DEFAULT_SSL_PORT
puts MQTT::SN::DEFAULT_PORT
puts MQTT::Exception.superclass
puts MQTT::ProtocolException.superclass
puts MQTT::NotConnectedException.superclass
puts MQTT::Exception.ancestors.include?(::Exception)
