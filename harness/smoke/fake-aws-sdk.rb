require 'fake-aws-sdk'

# Create a fake S3 instance
s3 = FakeAWS::S3.new

# Create buckets via the bucket collection
bucket_a = s3.buckets.create("my-bucket", location_constraint: "us-east-1")
bucket_b = s3.buckets.create("other-bucket")

puts bucket_a.name
puts bucket_a.location_constraint
puts bucket_a.exists?
puts bucket_a.empty?

# Write objects into the bucket
bucket_a.objects["hello.txt"].write("Hello, World!")
bucket_a.objects["data.csv"].write("col1,col2\n1,2\n3,4\n")

puts bucket_a.empty?
puts bucket_a.objects["hello.txt"].read
puts bucket_a.objects["hello.txt"].content_length
puts bucket_a.objects["data.csv"].content_length

# Test exists? on an object
puts bucket_a.objects["hello.txt"].exists?
puts bucket_a.objects["missing.txt"].exists?

# Copy an object
bucket_a.objects["hello.txt"].copy_to("hello_copy.txt")
puts bucket_a.objects["hello_copy.txt"].read

# Enumerable: list objects sorted by key
bucket_a.objects.each do |obj|
  puts obj.key
end

# BucketCollection enumerable: list bucket names sorted
s3.buckets.each do |b|
  puts b.name
end

# Delete an object, check it's gone
bucket_a.objects["hello.txt"].delete
puts bucket_a.objects["hello.txt"].exists?

# clear! removes all objects
bucket_a.clear!
puts bucket_a.empty?

# Access a bucket by [] (auto-creates)
auto = s3.buckets["auto-bucket"]
puts auto.name
puts auto.exists?
