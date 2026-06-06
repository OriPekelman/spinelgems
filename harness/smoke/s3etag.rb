require 's3etag'

# Small data: below threshold -> plain MD5
small = 'hello world'
r1 = S3Etag.calc(:data => small)
puts "small: #{r1}"

# Medium data: also below 16MB threshold -> plain MD5
medium = 'x' * 1000
r2 = S3Etag.calc(:data => medium)
puts "medium: #{r2}"

# Multipart: force multipart by setting low threshold and small part size
# Use 1000 bytes of data with 100-byte threshold and 100-byte min_part_size
data = 'a' * 1000
r3 = S3Etag.calc(:data => data, :threshold => 100, :min_part_size => 100)
puts "multipart: #{r3}"

# Another multipart: different content
data2 = ('b' * 150) + ('c' * 150)
r4 = S3Etag.calc(:data => data2, :threshold => 200, :min_part_size => 100)
puts "multipart2: #{r4}"
