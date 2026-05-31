require_relative "lib/add_magic_comment"

puts AddMagicComment::MAGIC_COMMENT_PREFIX
puts AddMagicComment::MAGIC_COMMENT
puts AddMagicComment::EXTENSION_COMMENTS.key?("*.rb")
puts AddMagicComment::EXTENSION_COMMENTS["*.rb"].strip
puts AddMagicComment::EXTENSION_COMMENTS.keys.length
puts AddMagicComment.detect_newline("hello\n")
puts AddMagicComment.detect_newline(nil).inspect
