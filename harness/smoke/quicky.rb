require 'quicky'

# Exercise TimeResult
r1 = Quicky::TimeResult.new(0.5)
puts r1.duration

# Exercise TimeCollector: accumulate known durations
tc = Quicky::TimeCollector.new("bench")
tc << Quicky::TimeResult.new(1.0)
tc << Quicky::TimeResult.new(3.0)
puts tc.name
puts tc.count
puts tc.total_duration
puts tc.duration
puts tc.max_duration
puts tc.min_duration

# Exercise merge!
tc2 = Quicky::TimeCollector.new("bench")
tc2 << Quicky::TimeResult.new(2.0)
tc.merge!(tc2)
puts tc.count
puts tc.total_duration
puts tc.max_duration
puts tc.min_duration

# Exercise to_hash keys
h = tc.to_hash
puts h[:name]
puts h[:count]
puts h[:total_duration]

# Exercise ResultsHash
rh = Quicky::ResultsHash.new
rh["x"] = tc
puts rh["x"].name
flat = rh.to_hash
puts flat["x"][:count]

# Exercise ResultsHash.from_hash round-trip (uses TimeCollector.from_hash)
rh2 = Quicky::ResultsHash.from_hash(flat)
puts rh2["x"].count
puts rh2["x"].name

# Exercise ResultsHash merge!
rh3 = Quicky::ResultsHash.new
tc3 = Quicky::TimeCollector.new("x")
tc3 << Quicky::TimeResult.new(10.0)
rh3["x"] = tc3
rh.merge!(rh3)
puts rh["x"].count

# Exercise Timer#time with a deterministic block
timer = Quicky::Timer.new
timer.loop(:fast, 3) { 1 + 1 }
col = timer.results(:fast)
puts col.count
puts col.total_duration >= 0
