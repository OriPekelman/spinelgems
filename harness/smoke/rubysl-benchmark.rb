# rubysl-benchmark smoke: Tms construction, arithmetic, formatting, measure/realtime
# The harness inlines lib/rubysl/benchmark/benchmark.rb via require_relative,
# so Benchmark is already defined when this body runs.

# Tms construction and attribute access with known values
t1 = Benchmark::Tms.new(1.0, 0.5, 0.1, 0.05, 2.0, "task1")
puts "utime=#{t1.utime}"
puts "stime=#{t1.stime}"
puts "cutime=#{t1.cutime}"
puts "cstime=#{t1.cstime}"
puts "real=#{t1.real}"
puts "total=#{t1.total}"
puts "label=#{t1.label}"

# Tms arithmetic: addition
t2 = Benchmark::Tms.new(0.5, 0.25, 0.05, 0.025, 1.0, "task2")
t3 = t1 + t2
puts "sum_utime=#{t3.utime}"
puts "sum_stime=#{t3.stime}"
puts "sum_total=#{t3.total}"
puts "sum_real=#{t3.real}"

# Tms arithmetic: multiply and divide
t4 = t1 * 2
puts "mul_utime=#{t4.utime}"
puts "mul_total=#{t4.total}"

t5 = t3 / 2
puts "div_utime=#{t5.utime}"
puts "div_real=#{t5.real}"

# Tms subtraction
t6 = t1 - t2
puts "sub_utime=#{t6.utime}"
puts "sub_real=#{t6.real}"

# Tms#to_a
arr = t1.to_a
puts "to_a_label=#{arr[0]}"
puts "to_a_utime=#{arr[1]}"

# Tms#format with custom format using %n, %u, %y, %t, %r
fmt = t1.format("n=%n u=%.3u y=%.3y t=%.3t r=%.3r")
puts fmt.strip

# CAPTION and FORMAT constants
puts "has_caption=#{Benchmark::CAPTION.include?('user')}"
puts "has_format=#{Benchmark::FORMAT.include?('%')}"

# Benchmark.measure returns a Tms
result = Benchmark.measure("blk") { 1 + 1 }
puts "measure_class=#{result.class}"
puts "measure_label=#{result.label}"
puts "measure_real_nonneg=#{result.real >= 0}"

# Benchmark.realtime returns a non-negative Float
elapsed = Benchmark.realtime { 1 + 1 }
puts "realtime_float=#{elapsed.is_a?(Float)}"
puts "realtime_nonneg=#{elapsed >= 0}"
