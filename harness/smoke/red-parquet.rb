# red-parquet smoke
# red-parquet wraps Apache Parquet via the red-arrow / GObject introspection
# native stack.  `require 'parquet'` immediately does `require "arrow"`, which
# is unavailable in this environment.  We surface the LoadError explicitly,
# then exercise the one pure-Ruby module (Parquet::Version) that the gem
# defines without any native dependency — its version-parsing logic splits
# the VERSION string and maps components to integers.

begin
  require 'parquet'
rescue LoadError => e
  puts "LoadError: #{e.message}"
end

# parquet/version has no native dependencies; load it directly.
begin
  require 'parquet/version'
rescue LoadError
  # already on $LOAD_PATH via -I, nothing else to do
end

if defined?(Parquet::VERSION)
  puts Parquet::VERSION
  puts Parquet::Version::MAJOR
  puts Parquet::Version::MINOR
  puts Parquet::Version::MICRO
  puts Parquet::Version::TAG.inspect
  puts Parquet::Version::STRING
end
