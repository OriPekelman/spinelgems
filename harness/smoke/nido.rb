n = Nido.new("app")
puts n
puts n["users"]
puts n["users"]["name"]
puts n["config"]["db"]["host"]
puts Nido.new("x")["y"]["z"]
