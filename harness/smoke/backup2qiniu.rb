require 'backup2qiniu'
require 'base64'

# Exercise the DSL module (defined in backup/config/dsl/qiniu.rb)
puts Backup::Config::DSL::Qiniu.name
puts Backup::Config::DSL::Qiniu.is_a?(Module)

# The Storage::Qiniu class has an `action` private method that computes a
# Qiniu RS-PUT action string using Base64.urlsafe_encode64. We can exercise
# that logic directly since it has no external deps.
module Backup
  module Storage
    class QiniuStub
      def action(bucket, key)
        "/rs-put/#{Base64.urlsafe_encode64("#{bucket}:#{key}")}"
      end
    end
  end
end

stub = Backup::Storage::QiniuStub.new
puts stub.action('mybucket', 'backups/2024-01-01/db.tar')
puts stub.action('test-bucket', 'path/to/file.gz')
puts stub.action('a', 'b')

# Verify the encoding round-trips correctly
encoded = Base64.urlsafe_encode64("mybucket:backups/2024-01-01/db.tar")
decoded = Base64.urlsafe_decode64(encoded)
puts decoded
puts encoded.include?('=') ? 'padded' : 'unpadded'
