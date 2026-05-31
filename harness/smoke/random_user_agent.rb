# Smoke: random_user_agent — deterministic API surface (Browser class only)
b = Browser.new
puts b.statistics.keys.sort.join(",")
puts b.statistics["Chrome"]
puts b.ie.length
puts b.firefox.length
puts b.ie.first
puts b.firefox.first
