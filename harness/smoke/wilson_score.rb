# WilsonScore smoke — pure Math, no external deps
# interval(k, n) returns a Range of floats; round to 6 dp for stability

r = WilsonScore.interval(10, 100, 0.95, false)
puts r.first.round(6)
puts r.last.round(6)

r2 = WilsonScore.interval(50, 200, 0.95, false)
puts r2.first.round(6)
puts r2.last.round(6)

lb = WilsonScore.lower_bound(30, 100, confidence: 0.95, correction: false)
puts lb.round(6)

puts WilsonScore::VERSION
