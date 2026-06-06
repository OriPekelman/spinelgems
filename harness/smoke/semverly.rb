require 'semverly'

# Parse and reconstruct version strings
v1 = SemVer.parse('1.2.3')
puts v1.to_s                    # => 1.2.3
puts v1.major                   # => 1
puts v1.minor                   # => 2
puts v1.patch                   # => 3

# Prerelease and metadata
v2 = SemVer.parse('2.0.0-alpha.1+build.123')
puts v2.to_s                    # => 2.0.0-alpha.1+build.123
puts v2.prerelease              # => alpha.1
puts v2.metadata                # => build.123

# Invalid parse returns nil
puts SemVer.parse('not-a-version').nil?  # => true

# Comparison: release beats pre-release
v3 = SemVer.parse('1.0.0-rc.1')
v4 = SemVer.parse('1.0.0')
puts (v3 < v4)                  # => true
puts (v4 > v3)                  # => true
puts (v4 <=> v3)                # => 1

# Sorting a mixed list by semver order
versions = ['1.10.0', '1.9.0', '2.0.0-beta', '2.0.0', '1.0.0-alpha'].map { |s| SemVer.parse(s) }
sorted = versions.sort.map(&:to_s)
puts sorted.join(', ')          # => 1.0.0-alpha, 1.9.0, 1.10.0, 2.0.0-beta, 2.0.0

# Numeric pre-release parts compare numerically not lexically
va = SemVer.parse('1.0.0-rc.9')
vb = SemVer.parse('1.0.0-rc.10')
puts (va < vb)                  # => true

# Equality
vc = SemVer.parse('3.4.5')
vd = SemVer.new(3, 4, 5)
puts (vc == vd)                 # => true
