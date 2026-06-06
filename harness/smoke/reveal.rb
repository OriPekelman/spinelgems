require 'reveal'
require 'zlib'
require 'stringio'

# Test 1: Read a plain string (coerce_to_file wraps in StringIO, reads back)
plain_text = "hello from reveal\nline two"
result1 = Reveal.read(plain_text)
puts result1

# Test 2: Build a gzipped byte string in memory, pass as raw string
gzip_buf = StringIO.new
gz = Zlib::GzipWriter.new(gzip_buf)
gz.write("compressed content\nsecond line")
gz.close
gzipped_string = gzip_buf.string

result2 = Reveal.read(gzipped_string)
puts result2

# Test 3: Pass a real File (is_a?(IO)==true) wrapping gzipped data
gz_path = '/tmp/reveal_smoke_test.gz'
File.open(gz_path, 'wb') { |f| f.write(gzipped_string) }
File.open(gz_path, 'rb') do |f|
  result3 = Reveal.read(f)
  puts result3
end
File.unlink(gz_path)

# Test 4: Pass a real File wrapping plain text
plain_path = '/tmp/reveal_smoke_plain.txt'
File.open(plain_path, 'w') { |f| f.write("file plain text\nfourth line") }
File.open(plain_path, 'r') do |f|
  result4 = Reveal.read(f)
  puts result4
end
File.unlink(plain_path)
