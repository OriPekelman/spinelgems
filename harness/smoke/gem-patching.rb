require 'gem-patching'

# Test 1: patching a non-loaded gem raises with the right message
begin
  Gem.patching('nonexistent-gem', '~> 1.0') { puts "should not run" }
  puts "ERROR: expected exception not raised"
rescue => e
  msg = e.message
  puts msg.include?("nonexistent-gem") ? "PASS: non-loaded gem raises" : "FAIL: unexpected message: #{msg}"
  puts msg.include?("not active") ? "PASS: message mentions not active" : "FAIL: no 'not active' in: #{msg}"
end

# Test 2: patching a loaded gem that satisfies requirements calls the block
# We inject a fake spec into loaded_specs to test the happy path
fake_spec = Gem::Specification.new do |s|
  s.name    = 'fake-gem'
  s.version = '2.3.0'
end
Gem.loaded_specs['fake-gem'] = fake_spec

begin
  yielded = false
  Gem.patching('fake-gem', '>= 2.0.0') { yielded = true }
  puts yielded ? "PASS: block yielded for matching version" : "FAIL: block not yielded"
rescue => e
  puts "FAIL: unexpected error for matching gem: #{e.message}"
end

# Test 3: patching a loaded gem that does NOT satisfy requirements raises
begin
  Gem.patching('fake-gem', '~> 3.0') { puts "should not run" }
  puts "ERROR: expected exception not raised"
rescue => e
  msg = e.message
  puts msg.include?("fake-gem") ? "PASS: version mismatch raises with gem name" : "FAIL: unexpected message: #{msg}"
  puts msg.include?("active version") ? "PASS: message mentions active version" : "FAIL: no 'active version' in: #{msg}"
end

# Test 4: patching with no block and matching version (no yield, no error)
begin
  Gem.patching('fake-gem', '= 2.3.0')
  puts "PASS: no block, matching version, no error"
rescue => e
  puts "FAIL: unexpected error: #{e.message}"
end

# Test 5: Gem::Dependency directly
dep = Gem::Dependency.new('my-dep', '>= 1.0', '< 3.0')
puts "PASS: Gem::Dependency name=#{dep.name}"
puts "PASS: satisfied by 2.0: #{dep.requirement.satisfied_by?(Gem::Version.new('2.0.0'))}"
puts "PASS: not satisfied by 0.9: #{!dep.requirement.satisfied_by?(Gem::Version.new('0.9.0'))}"
