require_relative "lib/taglib/version"

puts TagLib::Version::MAJOR
puts TagLib::Version::MINOR
puts TagLib::Version::PATCH
puts TagLib::Version::BUILD.nil?
puts TagLib::Version::STRING
