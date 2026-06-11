puts Any::VERSION
puts Any == 42
puts Any == "hello"
puts Any == nil
puts Any === :symbol
puts (Any === 3.14).to_s
p = Any.to_proc
puts p.call
puts p.call("anything")
