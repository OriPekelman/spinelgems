# Smoke: On gem - dynamic callback dispatch
result = nil

cb = On.new(:success, :failure) do |c|
  c.on(:success) { |msg| result = "success: #{msg}" }
  c.on(:failure) { |msg| result = "failure: #{msg}" }
end
cb.call(:success, "done")
puts result

cb2 = On.new(:success, :failure) do |c|
  c.on(:success) { |msg| result = "success: #{msg}" }
  c.on(:failure) { |msg| result = "failure: #{msg}" }
end
cb2.call(:failure, "oops")
puts result

# Check callbacks list
on3 = On.new(:a, :b, :c) { |_| }
on3.call(:a)
puts on3.callbacks.sort.inspect
puts on3.callback.name

# Callback struct
cb4 = On.new(:ping) do |c|
  c.on(:ping) { puts "pong" }
end
cb4.call(:ping)

# InvalidCallback error
begin
  On.new(:x) { |_| }.call(:y)
rescue On::InvalidCallback => e
  puts e.message
end
