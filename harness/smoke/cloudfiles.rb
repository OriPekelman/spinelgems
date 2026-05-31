# Smoke: cloudfiles - constants, version, exception class names, lines helper
puts CloudFiles::AUTH_USA
puts CloudFiles::AUTH_UK
puts CloudFiles::VERSION
puts CloudFiles.lines("hello\nworld\nfoo").inspect
puts SyntaxException.ancestors.include?(StandardError)
puts NoSuchObjectException.superclass
