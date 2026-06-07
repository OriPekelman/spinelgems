# frozen_string_literal: true

# Tebako smoke: Error class, PACKAGING_ERRORS table, packaging_error helper,
# and PackageDescriptor serialize/deserialize roundtrip.

require "tebako"
require "tebako/package_descriptor"

# 1. Tebako::Error — custom error with code attribute
err = Tebako::Error.new("something went wrong", 42)
puts err.message
puts err.error_code

# 2. PACKAGING_ERRORS table — spot-check a few entries
[101, 106, 109, 112].each do |code|
  puts "#{code}: #{Tebako::PACKAGING_ERRORS[code]}"
end

# 3. packaging_error class method — should raise Tebako::Error
begin
  Tebako.packaging_error(104)
rescue Tebako::Error => e
  puts "caught #{e.error_code}: #{e.message}"
end

# packaging_error with extension message
begin
  Tebako.packaging_error(106, "/no/such/file.rb")
rescue Tebako::Error => e
  puts "caught #{e.error_code}: #{e.message}"
end

# unknown code produces fallback message
begin
  Tebako.packaging_error(999)
rescue Tebako::Error => e
  puts "caught #{e.error_code}: #{e.message}"
end

# 4. PackageDescriptor serialize / deserialize roundtrip
pd = Tebako::PackageDescriptor.new("3.3.7", "0.14.0", "/__tebako_memfs__", "main.rb", "/app")
puts pd.ruby_version_major
puts pd.ruby_version_minor
puts pd.ruby_version_patch
puts pd.tebako_version_major
puts pd.tebako_version_minor
puts pd.tebako_version_patch
puts pd.mount_point
puts pd.entry_point
puts pd.cwd

blob = pd.serialize
puts blob.encoding
puts blob[0, 10]  # TAMATEBAKO signature

# Deserialize from raw bytes
bytes = blob.bytes
pd2 = Tebako::PackageDescriptor.new(bytes)
puts pd2.ruby_version_major
puts pd2.ruby_version_minor
puts pd2.ruby_version_patch
puts pd2.tebako_version_major
puts pd2.tebako_version_minor
puts pd2.tebako_version_patch
puts pd2.mount_point
puts pd2.entry_point
puts pd2.cwd

# Without cwd
pd3 = Tebako::PackageDescriptor.new("3.4.1", "0.14.0", "/__tebako_memfs__", "app.rb", nil)
puts pd3.cwd.nil?
blob3 = pd3.serialize
pd4 = Tebako::PackageDescriptor.new(blob3.bytes)
puts pd4.cwd.nil?
puts pd4.entry_point
