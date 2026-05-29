result = Pipe.run("echo hello")
puts result.chomp
result2 = Pipe.run("printf '%s\n' foo bar")
puts result2.chomp
