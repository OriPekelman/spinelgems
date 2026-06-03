require 'referer-parser'

# Exercise RefererParser::Parser with known search engine referers

parser = RefererParser::Parser.new

# 1. Google search with a query term
result = parser.parse('http://www.google.com/search?q=ruby+spinel&hl=en')
puts result[:known]
puts result[:medium]
puts result[:source]
puts result[:term]

# 2. Bing search
result2 = parser.parse('http://www.bing.com/search?q=open+source')
puts result2[:known]
puts result2[:medium]
puts result2[:source]
puts result2[:term]

# 3. Unknown / direct URL (not in DB)
result3 = parser.parse('http://www.example.com/')
puts result3[:known]
puts result3[:uri]

# 4. Parser clear! resets state
parser.clear!
result4 = parser.parse('http://www.google.com/search?q=test')
puts result4[:known]
