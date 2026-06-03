# frozen_string_literal: true

# mime-types-data: data-only gem providing MIME type registry path + version.
# Exercises: VERSION constant, PATH resolution via __FILE__-relative expand_path,
# and parsing the columnar data files bundled with the gem.

require "mime-types-data"

# 1. VERSION is a dotted-triple string
v = MIME::Types::Data::VERSION
puts "version: #{v}"
puts v.split(".").length == 3 ? "version_parts:3" : "version_parts:wrong"

# 2. PATH is resolved via File.expand_path relative to __FILE__ in data.rb
path = MIME::Types::Data::PATH
puts "path_is_dir: #{File.directory?(path)}"

# 3. Parse the bundled columnar data (real logic: each line = "type [ext...]")
lines = File.readlines(File.join(path, "mime.content_type.column"), chomp: true)
puts "total_types: #{lines.length}"

types_with_ext = lines.count { |l| l.include?(" ") }
puts "types_with_ext: #{types_with_ext}"

# 4. Spot-check well-known MIME types and their primary extensions
txt_line = lines.find { |l| l.start_with?("text/plain ") }
puts "text_plain_exts: #{txt_line.split(" ").drop(1).first(3).inspect}"

json_line = lines.find { |l| l.start_with?("application/json ") }
puts "json_exts: #{json_line.split(" ").drop(1).inspect}"

html_line = lines.find { |l| l.start_with?("text/html ") }
puts "text_html_found: #{!html_line.nil?}"
puts "text_html_ext_html: #{html_line&.split(' ')&.include?('html') ? true : false}"
