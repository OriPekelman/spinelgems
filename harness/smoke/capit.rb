require 'capit'

# Test VERSION constant
puts CapIt::VERSION

# Test EXTENSIONS regex matching
ext_regex = CapIt::Capture::EXTENSIONS
valid_files = ["screenshot.png", "capture.jpg", "output.jpeg", "page.pdf", "grab.gif", "image.bmp"]
invalid_files = ["file.txt", "image.exe", "page.html2", ""]

valid_files.each do |f|
  puts "valid: #{!f[ext_regex].nil?} #{f}"
end

invalid_files.each do |f|
  begin
    result = f[ext_regex]
    puts "valid: #{!result.nil?} #{f}"
  rescue => e
    puts "error: #{e.class} #{f}"
  end
end

# Test object initialization with valid filename (no CutyCapt needed just yet)
begin
  cap = CapIt::Capture.new("http://example.com", filename: "test.png", folder: "/tmp")
  puts "url: #{cap.url}"
  puts "folder: #{cap.folder}"
  puts "filename: #{cap.filename}"
  puts "max_wait: #{cap.max_wait}"
  puts "min_width: #{cap.min_width}"
  puts "min_height: #{cap.min_height}"
rescue => e
  puts "init error: #{e.class}: #{e.message}"
end

# Test invalid extension raises error
begin
  CapIt::Capture.new("http://example.com", filename: "test.txt")
  puts "no_error"
rescue CapIt::InvalidExtensionError => e
  puts "InvalidExtensionError: #{e.message}"
end

# Test determine_os
begin
  cap2 = CapIt::Capture.new("http://example.com", filename: "test.png")
  os = cap2.determine_os
  puts "os: #{os}"
rescue CapIt::InvalidOSError => e
  puts "InvalidOSError: #{e.message}"
end

# Test capture_command builds correct string (without actually running)
begin
  cap3 = CapIt::Capture.new("http://example.com",
    filename: "page.png",
    folder: "/tmp",
    max_wait: 5000,
    min_width: 800,
    min_height: 600,
    cutycapt_path: "/usr/bin/CutyCapt"
  )
  cmd = cap3.capture_command
  puts "has_url: #{cmd.include?("http://example.com")}"
  puts "has_out: #{cmd.include?("/tmp/page.png")}"
  puts "has_wait: #{cmd.include?("5000")}"
rescue => e
  puts "cmd error: #{e.class}: #{e.message}"
end

# Test filename= setter with valid extension
begin
  cap4 = CapIt::Capture.new("http://example.com", filename: "old.png")
  cap4.filename = "new.jpeg"
  puts "renamed: #{cap4.filename}"
rescue => e
  puts "rename error: #{e.class}: #{e.message}"
end

# Test filename= setter with invalid extension
begin
  cap5 = CapIt::Capture.new("http://example.com", filename: "old.png")
  cap5.filename = "bad.exe"
  puts "no_error_on_bad"
rescue CapIt::InvalidExtensionError => e
  puts "InvalidExtensionError on rename: #{e.message}"
end
