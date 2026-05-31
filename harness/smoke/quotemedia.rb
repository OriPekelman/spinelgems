# Smoke test for quotemedia gem
# Tests Chart URL generation with known parameters

chart = Quotemedia::Chart.new(symbol: 'AAPL')
url = chart.url
# The URL starts with the base and includes the symbol
puts url.start_with?('http://app.quotemedia.com/quotetools/getChart.go?')
puts url.include?('symbol=AAPL')
puts url.include?('webmasterId=500')
puts url.include?('chtype=AreaChart')
puts url.include?('chhig=250')

# Test with custom params overriding defaults
chart2 = Quotemedia::Chart.new(symbol: 'IBM', chscale: '1y', chtype: 'line')
url2 = chart2.url
puts url2.include?('symbol=IBM')
puts url2.include?('chscale=1y')
puts url2.include?('chtype=line')

# Test that error is raised without symbol
begin
  Quotemedia::Chart.new(chscale: '1d')
  puts 'no error'
rescue ArgumentError => e
  puts e.message
end
