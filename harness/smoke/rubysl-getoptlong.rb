# rubysl-getoptlong smoke: constants, ARGV-based option parsing (long + short), ordering
# The harness inlines all lib files via require_relative, so GetoptLong is defined.

# Test 1: argument-type and ordering constants
puts GetoptLong::NO_ARGUMENT
puts GetoptLong::REQUIRED_ARGUMENT
puts GetoptLong::OPTIONAL_ARGUMENT
puts GetoptLong::REQUIRE_ORDER
puts GetoptLong::PERMUTE
puts GetoptLong::RETURN_IN_ORDER

# Test 2: parse long options (inject into ARGV)
ARGV.replace(['--verbose', '--output', 'file.txt', '--mode=fast'])

opts = GetoptLong.new(
  ['--verbose', '-v', GetoptLong::NO_ARGUMENT],
  ['--output',  '-o', GetoptLong::REQUIRED_ARGUMENT],
  ['--mode',         GetoptLong::OPTIONAL_ARGUMENT]
)

results = []
opts.each do |opt, arg|
  results << "#{opt}=#{arg.empty? ? '(none)' : arg}"
end
results.sort.each { |r| puts r }

# Test 3: parse short options
ARGV.replace(['-v', '-o', 'out.txt'])

opts2 = GetoptLong.new(
  ['--verbose', '-v', GetoptLong::NO_ARGUMENT],
  ['--output',  '-o', GetoptLong::REQUIRED_ARGUMENT]
)
opts2.quiet = true

pairs = []
opts2.each { |o, a| pairs << [o, a] }
pairs.each { |o, a| puts "short: #{o} -> #{a.empty? ? '(none)' : a}" }

# Test 4: ordering accessor and quiet flag
ARGV.replace([])
opts3 = GetoptLong.new(['--flag', GetoptLong::NO_ARGUMENT])
puts opts3.ordering == GetoptLong::PERMUTE ? 'ordering:PERMUTE' : 'ordering:other'
puts opts3.quiet? ? 'quiet:true' : 'quiet:false'

# Test 5: terminated? before and after
ARGV.replace([])
opts4 = GetoptLong.new(['--x', GetoptLong::NO_ARGUMENT])
puts opts4.terminated? ? 'pre:terminated' : 'pre:running'
opts4.each { }
puts opts4.terminated? ? 'post:terminated' : 'post:running'
