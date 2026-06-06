require 'advanced_math'

# --- SimpleMovingAverage ---
sma = AdvancedMath::SimpleMovingAverage.new(3)
# Feed values one-by-one; first two return nil (insufficient window)
puts sma.add(10).inspect   # nil
puts sma.add(20).inspect   # nil
puts "%.4f" % sma.add(30)  # (10+20+30)/3 = 20.0000
puts "%.4f" % sma.add(40)  # (20+30+40)/3 = 30.0000

# SMA alias
sma2 = AdvancedMath::SMA.new(2)
results = sma2.add_array([5, 10, 15, 20])
# nils for first insufficient window, then averages
puts results[0].inspect    # nil
puts "%.4f" % results[1]   # 7.5
puts "%.4f" % results[2]   # 12.5
puts "%.4f" % results[3]   # 17.5

# --- RelativeStrengthIndex ---
rsi = AdvancedMath::RSI.new(3)
prices = [44.34, 44.09, 44.15, 43.61, 44.33, 44.83]
rsi_vals = rsi.add_array(prices)
# First 3 values should be nil (seeding), then RSI values
rsi_vals.each do |v|
  if v.nil?
    puts "nil"
  else
    puts "%.2f" % v
  end
end
