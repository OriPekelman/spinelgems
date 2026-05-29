# torquebox-no-op smoke: exercise the no-op stub API
puts TorqueBox::Messaging::Queue.ancestors.include?(TorqueBox::Messaging::Queue)
q = TorqueBox::Messaging::Queue.new("/queue/test")
puts q.publish("hello").inspect
puts q.receive.inspect

result = nil
TorqueBox.transaction("xa") { result = "yielded" }
puts result

puts TorqueBox::DummyResource.new.publish("x").inspect
puts TorqueBox::DummyResource.new.receive.inspect

puts TorqueBox::Stomp::JmsStomplet.new.destination_for("a").inspect
puts TorqueBox::Messaging::Message.register_encoding(String).inspect
