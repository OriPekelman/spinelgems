c = Accumulators::Count.new
c.add(1)
c.add(2)
c.add(3)
puts c.count

s = Accumulators::Sum.new
s.add(10)
s.add(20)
s.add(5)
puts s.sum

mm = Accumulators::MinMax.new
mm.add(7)
mm.add(3)
mm.add(9)
mm.add(1)
puts mm.min
puts mm.max

c2 = Accumulators::Count.new
c2.add(1)
c2.add(c)
puts c2.count
