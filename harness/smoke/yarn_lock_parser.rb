# Drive YarnLockParser::Parser constants — no file I/O, no stdlib needed
puts YarnLockParser::Parser::LOCKFILE_VERSION
puts YarnLockParser::Parser::TOKEN_TYPES[:boolean]
puts YarnLockParser::Parser::TOKEN_TYPES[:string]
puts YarnLockParser::Parser::TOKEN_TYPES[:eof]
puts YarnLockParser::Parser::TOKEN_TYPES[:newline]
puts YarnLockParser::Parser::TOKEN_TYPES.keys.sort.map(&:to_s).inspect
