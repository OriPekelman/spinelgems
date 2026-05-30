require_relative "lib/bump/version"
require_relative "lib/bump/domain/version_number"
require_relative "lib/bump/domain/version_number_factory"

puts Bump::VERSION

v = Bump::VersionNumber.new(1, 2, 3)
puts v.to_s

v.bump(:patch)
puts v.to_s

v.bump(:minor)
puts v.to_s

v.bump(:major)
puts v.to_s

v2 = Bump::VersionNumber.new(0, 0, 1, "alpha")
puts v2.to_s

v3 = Bump::VersionNumberFactory.from_string("2.5.10")
puts v3.to_s

v3.bump(:minor)
puts v3.to_s
