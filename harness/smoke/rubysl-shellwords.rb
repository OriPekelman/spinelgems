require 'shellwords'

# Shellwords.shellsplit / .split — parse shell-quoted strings
puts Shellwords.split('hello world').inspect
puts Shellwords.split('here are "two words"').inspect
puts Shellwords.split("it\\'s a test").inspect
puts Shellwords.split('echo "foo bar" baz').inspect

# Shellwords.shellescape — escape a string for shell use
puts Shellwords.escape('hello world').inspect
puts Shellwords.escape('').inspect
puts Shellwords.escape('file(name).txt').inspect
puts Shellwords.escape('no_special').inspect

# Shellwords.shelljoin — join array into shell-safe command string
puts Shellwords.join(['grep', 'foo bar', 'file.txt']).inspect
puts Shellwords.join(['ls', '-la', '/tmp/my dir']).inspect

# String extension methods
puts 'one two three'.shellsplit.inspect
puts '"quoted arg" plain'.shellsplit.inspect
puts 'hello world'.shellescape.inspect

# Array extension method
puts ['echo', 'hello world', 'done'].shelljoin.inspect
