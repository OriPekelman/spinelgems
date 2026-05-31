puts Hike::VERSION

ext = Hike::Extensions.new
ext << "js"
ext << ".css"
ext.push("rb", ".html")
puts ext.inspect
puts ext.length
puts ext.first
puts ext.include?(".js")
puts ext.include?(".css")
