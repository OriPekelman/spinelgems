puts Pingr.mode
Pingr.mode = :live
puts Pingr.mode
Pingr.mode = :test
puts Pingr.mode
puts Pingr::PingrError.superclass
begin
  Pingr.mode = :invalid
rescue Pingr::PingrError => e
  puts e.message
end
