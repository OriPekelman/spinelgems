# Smoke test for envme 0.3.0
# Exercises Configuration and pure string-transform methods

cfg = Envme::Configuration.new
puts cfg.url
puts cfg.acl_token

cfg2 = Envme::Configuration.new("myhost:8500", "mytoken")
puts cfg2.url
puts cfg2.acl_token

Envme.configure do |c|
  c.url = "custom:9000"
end
puts Envme.configuration.url

vars = ["APP_FOO=bar", "APP_BAZ=qux"]
puts Envme.build_exports(vars)
puts Envme.file_builder(vars, "out.env")
