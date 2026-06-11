# Libring smoke — Contact + Product pure in-memory API
c = Libring::Contact.new("user-42")
puts c.contact_code

c.update_location("US", "CA", "San Francisco")
loc = c.get_location
puts loc["country"]
puts loc["state"]
puts loc["city"]

c.add_attribute("age", "30", "integer")
c.add_attribute("name", "Alice", "string")
attrs = c.get_attributes
puts attrs["age"]["value"]
puts attrs["age"]["type"]
puts attrs["name"]["value"]

# invalid add_attribute returns error message
puts c.add_attribute("", "x", "string")

p = Libring::Product.new("SKU-001")
p.set_name("Widget")
p.set_category("hardware")
p.set_unit_amount(9.99)
p.set_quantity(3)
puts p.sku
puts p.name
puts p.category
puts p.unit_amount
puts p.quantity
