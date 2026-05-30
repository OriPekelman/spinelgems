n = Noop.new
n.noop
n.noop(1, 2, 3)
n.noop("hello")
r = n.roc
puts r.class
puts n.class
puts n.noop.nil?
