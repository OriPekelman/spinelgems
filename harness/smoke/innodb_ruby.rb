# Smoke for innodb_ruby: drive Innodb::Checksum pure-math API.
# The harness finds no lib/innodb_ruby.rb entry, so we require the
# dep-free subfiles ourselves via require_relative (resolved from the
# gem root, where the harness places __spinel_verify.rb).
require_relative "lib/innodb/checksum"
require_relative "lib/innodb/version"

puts Innodb::VERSION

puts Innodb::Checksum.fold_pair(0, 0)
puts Innodb::Checksum.fold_pair(1, 2)
puts Innodb::Checksum.fold_pair(255, 65535)

puts Innodb::Checksum.fold_string("hello")
puts Innodb::Checksum.fold_string("InnoDB")
puts Innodb::Checksum.fold_string("")
