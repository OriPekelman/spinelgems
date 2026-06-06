# frozen_string_literal: true

require "bucket_store"
require "logger"

# Silence logger output so the smoke diff is clean
BucketStore.configure do |config|
  config.logger = Logger.new(nil)
end

# 1. KeyContext parsing
ctx = BucketStore::KeyContext.parse("inmemory://my-bucket/path/to/file.txt")
puts ctx.adapter    # => inmemory
puts ctx.bucket     # => my-bucket
puts ctx.key        # => path/to/file.txt

# 2. UriBuilder.sanitize
puts BucketStore::UriBuilder.sanitize("hello{world}%foo<bar>")
# => hello__world____foo__bar__

# 3. InMemory adapter via BucketStore.for — upload! and download
store = BucketStore.for("inmemory://testbucket/docs/hello.txt")
result_key = store.upload!("Hello, BucketStore!")
puts result_key     # => inmemory://testbucket/docs/hello.txt

downloaded = BucketStore.for("inmemory://testbucket/docs/hello.txt").download
puts downloaded[:bucket]   # => testbucket
puts downloaded[:key]      # => docs/hello.txt
puts downloaded[:content]  # => Hello, BucketStore!

# 4. exists? — before and after deletion
puts BucketStore.for("inmemory://testbucket/docs/hello.txt").exists?  # => true
BucketStore.for("inmemory://testbucket/docs/hello.txt").delete!
puts BucketStore.for("inmemory://testbucket/docs/hello.txt").exists?  # => false

# 5. list — upload multiple keys and list with prefix
BucketStore.for("inmemory://testbucket/logs/2024/jan.log").upload!("jan")
BucketStore.for("inmemory://testbucket/logs/2024/feb.log").upload!("feb")
BucketStore.for("inmemory://testbucket/logs/2024/mar.log").upload!("mar")
BucketStore.for("inmemory://testbucket/other/file.txt").upload!("other")

keys = BucketStore.for("inmemory://testbucket/logs/").list.to_a.sort
puts keys.length   # => 3
keys.each { |k| puts k }

# 6. filename helper
puts BucketStore.for("inmemory://testbucket/logs/2024/jan.log").filename  # => jan.log
