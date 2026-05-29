class Publisher
  include Cry

  def do_something(value)
    publish(:data, value)
    publish(:done)
  end
end

p = Publisher.new
results = []
p.on(:data) { |v| results << "data:#{v}" }
p.on(:done) { results << "done" }
p.do_something(42)
puts results.join(",")

p2 = Publisher.new
p2.on(:ping) { |x| puts "ping:#{x}" }
p2.on(:ping) { |x| puts "pong:#{x}" }
p2.send(:publish, :ping, "test")
