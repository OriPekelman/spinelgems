require_relative "lib/activerecord-clean-db-structure/version"
require_relative "lib/activerecord-clean-db-structure/clean_dump"

puts ActiveRecordCleanDbStructure::VERSION

sql = "-- Dumped by pg_dump version 14.1\nSET row_security = off;\nSET idle_in_transaction_session_timeout = 0;\nCREATE TABLE public.users (\n    id integer NOT NULL,\n    name text\n);\n\n\nCOMMENT ON EXTENSION plpgsql IS 'whatever';\n"
d = ActiveRecordCleanDbStructure::CleanDump.new(sql.dup)
d.run
puts d.dump
