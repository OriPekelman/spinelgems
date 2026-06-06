require 'pg/dsn_parser'

# Basic key=value DSN
result = PG::DSNParser.parse("host=localhost port=5432 dbname=mydb user=admin")
puts result[:host]
puts result[:port]
puts result[:dbname]
puts result[:user]

# Quoted value with spaces
result2 = PG::DSNParser.parse("host=db.example.com dbname='my database' password='s3cr3t'")
puts result2[:host]
puts result2[:dbname]
puts result2[:password]

# Escaped single quote in quoted value
result3 = PG::DSNParser.parse("host=localhost password='it\\'s fine'")
puts result3[:password]

# DSN with sslmode
result4 = PG::DSNParser.parse("host=pg.internal sslmode=require connect_timeout=10")
puts result4[:sslmode]
puts result4[:connect_timeout]

# VERSION constant
puts PG::DSNParser::VERSION
