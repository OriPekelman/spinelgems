c = Prometheus::Client::Counter.new(:hits, docstring: "hits")
c.increment(by: 3)
c.increment
puts "counter=#{c.get}"
g = Prometheus::Client::Gauge.new(:temp, docstring: "temp")
g.set(21)
puts "gauge=#{g.get}"
