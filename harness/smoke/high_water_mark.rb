# Smoke: high_water_mark — HighWaterMark::Error hierarchy
puts HighWaterMark::Error.superclass
puts HighWaterMark::Error.ancestors.include?(StandardError)
puts HighWaterMark::Error.new("boom").message
puts HighWaterMark::Error < StandardError
puts (HighWaterMark::Error < RuntimeError).inspect
