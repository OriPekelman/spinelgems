require 'ystock'

# ystock makes HTTP requests to Yahoo Finance, so we can't call Ystock.quote
# directly without network access. Instead we exercise the private `format`
# method directly (via send) with crafted CSV data that mirrors what Yahoo
# Finance returns. This is the core parsing logic of the gem.

# A sample CSV response: price,change,volume,symbol,change_percent,open,day_high,day_low,prev_close,ah_change,ma50,ma200,52wk_range,pe_ratio,exchange,float,short_ratio
sample_csv = <<~CSV
  150.25,-1.50,45678900,"AAPL","-0.99%",151.00,152.00,149.50,151.75,"-0.25%",148.00,145.00,"140.00 - 165.00",28.50,"NMS",15234567890,1.23
  342.10,+2.30,12345678,"MSFT","+0.68%",340.00,343.50,339.00,339.80,"+0.10%",330.00,310.00,"290.00 - 360.00",35.20,"NMS",7456789000,2.10
CSV

# Call the private class method
results = Ystock.send(:format, sample_csv)

puts "Parsed #{results.length} stock(s)"

stock1 = results[0]
puts "Symbol: #{stock1[:symbol]}"
puts "Price: #{stock1[:price]}"
puts "Change: #{stock1[:change]}"
puts "Change percent: #{stock1[:change_percent]}"
puts "Open: #{stock1[:open]}"
puts "Day high: #{stock1[:day_high]}"
puts "Day low: #{stock1[:day_low]}"
puts "Previous close: #{stock1[:previous_close]}"
puts "MA50: #{stock1[:ma50]}"
puts "MA200: #{stock1[:ma200]}"
puts "52-week range: #{stock1[:week52_range]}"
puts "PE ratio: #{stock1[:pe_ratio]}"
puts "Exchange: #{stock1[:exchange]}"

stock2 = results[1]
puts "---"
puts "Symbol: #{stock2[:symbol]}"
puts "Price: #{stock2[:price]}"
puts "Change percent: #{stock2[:change_percent]}"
puts "52-week range: #{stock2[:week52_range]}"

# Verify service URI is set
puts "---"
puts "Service URI includes yahoo.com: #{Ystock.class_variable_get(:@@service_uri).include?('yahoo')}"
