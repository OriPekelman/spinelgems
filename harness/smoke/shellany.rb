require 'shellany'
require 'shellany/sheller'

# Test 1: VERSION constant
puts Shellany::VERSION

# Test 2: Sheller.stdout - run a command and capture stdout
out = Shellany::Sheller.stdout('echo', 'hello shellany')
puts out.strip

# Test 3: Sheller.run returns true for success
result = Shellany::Sheller.run('true')
puts result.inspect

# Test 4: Sheller.run returns false for failure
result = Shellany::Sheller.run('false')
puts result.inspect

# Test 5: instance-style: ran? / ok? / stdout / stderr
sh = Shellany::Sheller.new('echo', 'world')
puts sh.ran?.inspect
sh.run
puts sh.ran?.inspect
puts sh.ok?.inspect
puts sh.stdout.strip

# Test 6: stderr capture
sh2 = Shellany::Sheller.new('sh', '-c', 'echo errout >&2')
sh2.run
puts sh2.stderr.strip

# Test 7: ArgumentError when no command given
begin
  Shellany::Sheller.new
rescue ArgumentError => e
  puts e.message
end

# Test 8: _shellize_if_needed is a no-op on MRI (non-java platform)
args = ['echo hello']
result = Shellany::Sheller._shellize_if_needed(args)
puts result == args ? 'passthrough' : 'shellized'
