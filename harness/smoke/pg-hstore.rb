require 'pg_hstore'

# Exercise PgHstore.dump (hash -> hstore string) and PgHstore.load (hstore string -> hash)

# 1. Basic round-trip with string keys and values
h1 = { "name" => "Alice", "city" => "Paris" }
dumped1 = PgHstore.dump(h1, true)   # raw_string = true
puts dumped1

loaded1 = PgHstore.load(dumped1)
puts loaded1["name"]
puts loaded1["city"]

# 2. Dump with nil value (NULL in hstore)
h2 = { "active" => nil, "score" => "42" }
dumped2 = PgHstore.dump(h2, true)
puts dumped2

loaded2 = PgHstore.load(dumped2)
puts loaded2["active"].inspect
puts loaded2["score"]

# 3. Values with special characters (backslash, double-quote)
h3 = { "path" => 'C:\\Windows', "label" => 'say "hi"' }
dumped3 = PgHstore.dump(h3, true)
loaded3 = PgHstore.load(dumped3)
puts loaded3["path"]
puts loaded3["label"]

# 4. dump with raw_string=false produces E'...' SQL constant
sql_const = PgHstore.dump({ "k" => "v" })
puts sql_const.start_with?("E'")

# 5. Symbolize keys
loaded5 = PgHstore.load('"foo"=>"bar"', true)
puts loaded5[:foo]

# 6. Parse alias
loaded6 = PgHstore.parse('"x"=>"1","y"=>"2"')
puts loaded6["x"]
puts loaded6["y"]
