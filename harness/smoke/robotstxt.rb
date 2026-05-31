puts Robotstxt::NAME
puts Robotstxt::GEM
puts Robotstxt::VERSION
puts Robotstxt::AUTHORS.first

p = Robotstxt::Parser.new('googlebot')
puts p.robot_id
puts p.rules.length
puts p.sitemaps.length
puts p.found?
