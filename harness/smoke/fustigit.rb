# fustigit: URI extensions for git/ssh/scp
# The TripletHandling module is included into URI and provides these class methods.
puts URI.default_triplet_type
u = URI.parse("git://github.com/foo/bar.git")
puts u.scheme
puts u.host
puts u.path
puts u.class
