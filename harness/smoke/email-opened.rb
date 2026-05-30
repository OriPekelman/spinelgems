eo = EmailOpened.new("mykey123", 2, "development")
puts eo.api_path
puts eo.headers["Content-Type"]
puts eo.headers["Authorization"]
puts eo.headers["Accept"]

eo2 = EmailOpened.new("testkey", 1, false)
puts eo2.api_path
puts eo2.headers["Accept"]

eo3 = EmailOpened.new("k", 3, "edge")
puts eo3.api_path
