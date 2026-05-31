f = FakeFtp::File.new('hello.txt', 'world', :passive)
puts f.name
puts f.bytes
puts f.passive?
puts f.active?
puts f.basename

f2 = FakeFtp::File.new('path/to/file.rb', 42, :active)
puts f2.name
puts f2.bytes
puts f2.passive?
puts f2.active?
puts f2.basename
