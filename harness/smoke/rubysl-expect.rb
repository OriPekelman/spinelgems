puts $expect_verbose.inspect
r, w = IO.pipe
w.write("hello world\n")
w.close
result = r.expect("hello")
puts result[0].strip
r.close
