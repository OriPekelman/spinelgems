config = HelpfulConfiguration.new
config.explain("host", "The database host")
config.explain("port", "The database port")
config["host"] = "localhost"
config["port"] = "5432"
puts config["host"]
puts config["port"]
puts config.configured?("host")
puts config.configured?("port")
puts config.with_default("default_host", "host")
puts config.with_default("fallback", "port")

config2 = HelpfulConfiguration.new({"name" => "test"})
config2.explain("name", "The app name")
puts config2["name"]
puts config2.configured?("name")
