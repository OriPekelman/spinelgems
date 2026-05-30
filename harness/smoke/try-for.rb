# try_for: retry-until-success helper
# Happy path: block succeeds on first try, returns immediately
result = nil
try_for(10) { result = 42 }
puts result

# Always-raises block with 0-second window: loop exits immediately, then raises on final yield
begin
  try_for(0) { raise "nope" }
rescue RuntimeError => e
  puts e.message
end

# Counter via mutable state: block succeeds on 3rd call
count = 0
try_for(10) do
  count += 1
  raise "not yet" unless count >= 3
end
puts count
