puts Which::VERSION
puts Which.options.inspect
puts Which.which('__nonexistent_program_xyz__').inspect
puts Which.which('__nonexistent_program_xyz__', array: true).inspect
Which.options = { all: false }
puts Which.options.inspect
Which.options = {}
puts Which.options.inspect
