# tty-cursor smoke — pure ANSI escape methods, no external deps
puts TTY::Cursor::VERSION.inspect
puts TTY::Cursor.up(3).inspect
puts TTY::Cursor.down(2).inspect
puts TTY::Cursor.forward(5).inspect
puts TTY::Cursor.backward(1).inspect
puts TTY::Cursor.move_to(0, 0).inspect
puts TTY::Cursor.move_to.inspect
puts TTY::Cursor.clear_line.inspect
puts TTY::Cursor.clear_screen.inspect
puts TTY::Cursor.column(4).inspect
