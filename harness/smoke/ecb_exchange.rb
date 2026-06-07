# frozen_string_literal: true

require 'ecb_exchange'
require 'date'
require 'bigdecimal'
require 'socket'
require 'thread'

# Minimal ECB-shaped XML document covering two dates
SAMPLE_XML = <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <gesmes:Envelope xmlns:gesmes="http://www.gesmes.org/xml/2002-08-01"
                   xmlns="http://www.ecb.int/vocabulary/2002-08-01/eurofxref">
    <Cube>
      <Cube time="2024-01-15">
        <Cube currency="USD" rate="1.0934"/>
        <Cube currency="GBP" rate="0.8570"/>
        <Cube currency="JPY" rate="158.02"/>
        <Cube currency="CHF" rate="0.9319"/>
      </Cube>
      <Cube time="2024-01-12">
        <Cube currency="USD" rate="1.0980"/>
        <Cube currency="GBP" rate="0.8600"/>
        <Cube currency="JPY" rate="157.50"/>
        <Cube currency="CHF" rate="0.9350"/>
      </Cube>
    </Cube>
  </gesmes:Envelope>
XML

# Spin up a minimal HTTP server using TCPServer (pure stdlib)
server = TCPServer.new('127.0.0.1', 0)
port = server.addr[1]

server_thread = Thread.new do
  loop do
    begin
      client = server.accept
    rescue IOError, Errno::EBADF
      break
    end
    # Drain the HTTP request headers
    while (line = client.gets)
      break if line.strip.empty?
    end
    response = "HTTP/1.0 200 OK\r\nContent-Type: application/xml\r\nContent-Length: #{SAMPLE_XML.bytesize}\r\n\r\n#{SAMPLE_XML}"
    client.write(response)
    client.close
  end
end

at_exit do
  server.close rescue nil
  server_thread.kill rescue nil
end

# Point XMLFeed at our local server
ECB::Exchange::XMLFeed.endpoint = "http://127.0.0.1:#{port}/rates.xml"

# ---- Exercise public API ----

date = Date.new(2024, 1, 15)

# 1. Fetch rates for a given date — exercises XMLFeed.rates + XML parsing
rates = ECB::Exchange::XMLFeed.rates(date)
currencies = rates.keys.sort
puts "currencies: #{currencies.join(',')}"

# 2. EUR is always 1.0 (base currency injected by parse)
puts "EUR rate: #{rates['EUR']}"

# 3. ECB::Exchange.rate — EUR→USD
usd_rate = ECB::Exchange.rate(from: 'EUR', to: 'USD', date: date)
puts "EUR->USD rate: #{usd_rate.round(4)}"

# 4. ECB::Exchange.rate — USD→GBP (cross rate)
usd_to_gbp = ECB::Exchange.rate(from: 'USD', to: 'GBP', date: date)
puts "USD->GBP rate: #{usd_to_gbp.round(4)}"

# 5. ECB::Exchange.convert — 100 EUR → JPY
jpy_amount = ECB::Exchange.convert(100, from: 'EUR', to: 'JPY', date: date)
puts "100 EUR in JPY: #{jpy_amount.round(2)}"

# 6. ECB::Exchange.convert — 50 USD → CHF
chf_amount = ECB::Exchange.convert(50, from: 'USD', to: 'CHF', date: date)
puts "50 USD in CHF: #{chf_amount.round(4)}"

# 7. CurrencyNotFoundError for unknown currency
begin
  ECB::Exchange.rate(from: 'EUR', to: 'XYZ', date: date)
rescue ECB::Exchange::CurrencyNotFoundError => e
  puts "CurrencyNotFoundError: #{e.message}"
end

# 8. DateNotFoundError for a date not in the feed
begin
  ECB::Exchange::XMLFeed.rates(Date.new(2000, 1, 1))
rescue ECB::Exchange::DateNotFoundError => e
  puts "DateNotFoundError: #{e.message}"
end

# 9. MemoryCache round-trip
cache = ECB::Exchange::MemoryCache.new
cache.write('test_key', {a: 1})
puts "MemoryCache read: #{cache.read('test_key')}"
cache.clear
puts "MemoryCache after clear: #{cache.read('test_key').inspect}"

# 10. VERSION constant
puts "VERSION: #{ECB::Exchange::VERSION}"
