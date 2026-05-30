puts Terminal::Size::VERSION
puts Terminal.send(:_height_width_hash_from, 24, 80).inspect
