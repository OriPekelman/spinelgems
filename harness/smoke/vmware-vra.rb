# frozen_string_literal: true
# Smoke test for vmware-vra gem
# Exercises Vra::RequestParameters and Vra::RequestParameter — pure-Ruby
# parameter-bag logic that builds deployment request payloads.
# ffi_yajl and passwordmasker are available as stubs in lib/ for environments
# where the C extensions are not installed.

require "vra"

# 1. VERSION
puts Vra::VERSION

# 2. RequestParameter basic: string type formatting
p_str = Vra::RequestParameter.new("region", "string", "us-east-1")
puts p_str.key
puts p_str.format_value.inspect

# 3. RequestParameter: integer type
p_int = Vra::RequestParameter.new("count", "integer", "7")
puts p_int.format_value

# 4. RequestParameter: boolean type truthy
p_bool_t = Vra::RequestParameter.new("enabled", "boolean", "true")
puts p_bool_t.format_value.inspect

# 5. RequestParameter: boolean type falsy
p_bool_f = Vra::RequestParameter.new("debug", "boolean", "false")
puts p_bool_f.format_value.inspect

# 6. RequestParameter: unknown/nil type returns value as-is
p_other = Vra::RequestParameter.new("tag", nil, "web-server")
puts p_other.format_value.inspect

# 7. RequestParameter: children + to_h (nested param hierarchy)
parent = Vra::RequestParameter.new("network", nil, nil)
child_vlan = Vra::RequestParameter.new("vlan", "string", "vlan-100")
child_mtu  = Vra::RequestParameter.new("mtu",  "integer", "1500")
parent.add_child(child_vlan)
parent.add_child(child_mtu)
puts parent.children.length
nested_h = parent.to_h
puts nested_h["network"]["vlan"].inspect
puts nested_h["network"]["mtu"]

# 8. RequestParameters#set and to_h
rp = Vra::RequestParameters.new
rp.set("region",   "string",  "us-east-1")
rp.set("replicas", "integer", "3")
rp.set("enabled",  "boolean", "true")
h = rp.to_h
puts h["region"].inspect
puts h["replicas"]
puts h["enabled"].inspect

# 9. RequestParameters#to_vra (API payload shape)
v = rp.to_vra
puts v[:inputs]["region"].inspect
puts v[:inputs]["replicas"]
puts v[:inputs]["enabled"].inspect

# 10. RequestParameters tilde-nested key (a~b~c creates a/b/c hierarchy)
rp2 = Vra::RequestParameters.new
rp2.set("storage~disk~size", "integer", "100")
h2 = rp2.to_h
puts h2["storage"].class
puts h2["storage"]["disk"].class
# leaf must not be accessible at flat root
puts h2.key?("storage~disk~size")

# 11. RequestParameters#set_parameters with typed hash
rp3 = Vra::RequestParameters.new
rp3.set_parameters("flavor", { type: "string", value: "medium" })
puts rp3.to_h["flavor"].inspect

# 12. RequestParameters#delete removes entries
rp4 = Vra::RequestParameters.new
rp4.set("x", "string", "hello")
rp4.set("y", "string", "world")
rp4.delete("x")
puts rp4.all_entries.length
puts rp4.to_h["y"].inspect

# 13. Exception hierarchy
puts Vra::Exception::DuplicateItemsDetected.ancestors.include?(RuntimeError)
puts Vra::Exception::NotFound.ancestors.include?(RuntimeError)
puts Vra::Exception::RequestError.ancestors.include?(RuntimeError)
puts Vra::Exception::Unauthorized.ancestors.include?(RuntimeError)
puts Vra::Exception::HTTPError.ancestors.include?(RuntimeError)
puts Vra::Exception::HTTPNotFound.ancestors.include?(Vra::Exception::HTTPError)
