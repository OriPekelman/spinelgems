class Box; include Mutex_m; end
b = Box.new
puts "sync=#{b.mu_synchronize { 40 + 2 }}"
puts "trylock=#{b.mu_try_lock}"
b.mu_unlock
puts "done"
