# Smoke test for quantile gem
# Tests Quantile::VERSION, Quantile::Quantile, and Quantile::Estimator

puts Quantile::VERSION

# Test Quantile invariant creation
q50 = Quantile::Quantile.new(0.5, 0.05)
puts q50.quantile
puts q50.inaccuracy

q99 = Quantile::Quantile.new(0.99, 0.001)
puts q99.quantile
puts q99.inaccuracy

# Test Estimator with known values — insert 1..100, query median and p99
e = Quantile::Estimator.new(
  Quantile::Quantile.new(0.5, 0.05),
  Quantile::Quantile.new(0.99, 0.001)
)
(1..100).each { |v| e.observe(v) }
puts e.observations
puts e.sum
# median within 5% of 50, p99 within 0.1% of 99 — just print the values
puts e.query(0.5)
puts e.query(0.99)
