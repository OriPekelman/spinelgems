require 'stringglob'

# Test regexp_string: glob pattern -> regex string
puts StringGlob.regexp_string('*.rb')
puts StringGlob.regexp_string('foo?.txt')
puts StringGlob.regexp_string('foo/*/bar')
puts StringGlob.regexp_string('{a,b,c}.txt')
puts StringGlob.regexp_string('**')
puts StringGlob.regexp_string('foo\\.rb')

# Test with STAR_MATCHES_LEADING_DOT (bit set: star does NOT match leading dot)
puts StringGlob.regexp_string('*.rb', StringGlob::STAR_MATCHES_LEADING_DOT)

# Test STAR_MATCHES_SLASH (bit set: star matches slash)
puts StringGlob.regexp_string('*.rb', StringGlob::STAR_MATCHES_SLASH)

# Test IGNORE_CASE
puts StringGlob.regexp_string('*.rb', StringGlob::IGNORE_CASE)

# Combine options
puts StringGlob.regexp_string('*.rb', StringGlob::IGNORE_CASE | StringGlob::STAR_MATCHES_SLASH)

# Match using the regexp_string result manually
re1 = Regexp.new("\\A#{StringGlob.regexp_string('*.rb')}\\z")
puts re1 === 'hello.rb'
puts re1 === 'hello.py'
puts re1 === '.hidden.rb'  # false because star won't match leading dot by default

re2 = Regexp.new("\\A#{StringGlob.regexp_string('{foo,bar}.txt')}\\z")
puts re2 === 'foo.txt'
puts re2 === 'bar.txt'
puts re2 === 'baz.txt'

re3 = Regexp.new("\\A#{StringGlob.regexp_string('foo?.txt')}\\z")
puts re3 === 'fooA.txt'
puts re3 === 'foo.txt'
