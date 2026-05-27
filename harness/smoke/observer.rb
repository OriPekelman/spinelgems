class Ticker; include Observable; def go; changed; notify_observers("tick", 7); end; end
class Watch; def update(m, n); puts "#{m}:#{n}"; end; end
t = Ticker.new; t.add_observer(Watch.new); t.go
puts "count=#{t.count_observers}"
