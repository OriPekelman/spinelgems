# Smoke: gollum-rugged_adapter
# Exercises pure-Ruby classes: Actor, Blob (with stubs for rugged C-ext).
# rugged requires a native C extension (libgit2); not available in the
# harness environment. Stub Rugged module + mark it loaded so the adapter
# can load and the pure-Ruby surface can be tested.

module Rugged
  module Config
    def self.global(key); nil; end
  end
  class ReferenceError < StandardError; end
  class TreeError    < StandardError; end
  class OdbError     < StandardError; end
  class InvalidError < StandardError; end
  class IndexError   < StandardError; end
  class PathError    < StandardError; end
end

module MIME
  module Types
    def self.type_for(name); []; end
  end
end

$LOADED_FEATURES << 'rugged' << 'mime-types' << 'mime/types'

require 'rugged_adapter'

# 1. Actor: constructor + accessors
actor = Gollum::Git::Actor.new('Alice Wonder', 'alice@example.com')
puts actor.name
puts actor.email
puts actor.to_h.inspect

# 2. Actor#output — exercises %-format string with UTC offset
t = Time.at(1_700_000_000).utc   # fixed epoch, always UTC (+0000)
puts actor.output(t)

# 3. default_actor class method
da = Gollum::Git::Actor.default_actor
puts da.name
puts da.email

# 4. Module-level no-op methods (must not raise)
Gollum.set_git_timeout(30)
Gollum.set_git_max_filesize(1_048_576)
puts 'no-ops ok'

# 5. DEFAULT_MIME_TYPE constant
puts Gollum::Git::DEFAULT_MIME_TYPE

# 6. NoSuchShaFound is a StandardError subclass
puts Gollum::Git::NoSuchShaFound.ancestors.include?(StandardError)

# 7. Blob: symlink detection via mode
fake_blob = Struct.new(:oid, :content, :size).new('a' * 40, 'target', 6)
blob_sym = Gollum::Git::Blob.new(fake_blob, mode: 0120000, name: 'link', size: 6)
puts blob_sym.is_symlink

blob_reg = Gollum::Git::Blob.new(fake_blob, mode: 0100644, name: 'file.rb', size: 6)
puts blob_reg.is_symlink
puts blob_reg.name
puts blob_reg.id
puts blob_reg.mime_type
