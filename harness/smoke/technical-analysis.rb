require 'technical-analysis'

# Build deterministic price data (20 entries)
prices = [
  { date_time: '2024-01-01', value: 100.0 },
  { date_time: '2024-01-02', value: 102.0 },
  { date_time: '2024-01-03', value: 101.5 },
  { date_time: '2024-01-04', value: 103.0 },
  { date_time: '2024-01-05', value: 105.0 },
  { date_time: '2024-01-06', value: 104.0 },
  { date_time: '2024-01-07', value: 106.0 },
  { date_time: '2024-01-08', value: 108.0 },
  { date_time: '2024-01-09', value: 107.0 },
  { date_time: '2024-01-10', value: 109.0 },
  { date_time: '2024-01-11', value: 110.0 },
  { date_time: '2024-01-12', value: 108.5 },
  { date_time: '2024-01-13', value: 111.0 },
  { date_time: '2024-01-14', value: 112.0 },
  { date_time: '2024-01-15', value: 113.5 },
  { date_time: '2024-01-16', value: 112.0 },
  { date_time: '2024-01-17', value: 114.0 },
  { date_time: '2024-01-18', value: 115.0 },
  { date_time: '2024-01-19', value: 116.0 },
  { date_time: '2024-01-20', value: 115.5 },
]

# SMA with period=5
sma_results = TechnicalAnalysis::Sma.calculate(prices, period: 5)
puts "SMA(5) count: #{sma_results.size}"
top = sma_results.first
puts "SMA(5) latest date: #{top.date_time}"
puts "SMA(5) latest value: #{top.sma.round(4)}"

# EMA with period=5
ema_results = TechnicalAnalysis::Ema.calculate(prices, period: 5)
puts "EMA(5) count: #{ema_results.size}"
puts "EMA(5) latest date: #{ema_results.first.date_time}"
puts "EMA(5) latest value: #{ema_results.first.ema.round(4)}"

# RSI with period=5 (needs period+1 = 6 data points minimum; we have 20)
rsi_results = TechnicalAnalysis::Rsi.calculate(prices, period: 5)
puts "RSI(5) count: #{rsi_results.size}"
puts "RSI(5) latest date: #{rsi_results.first.date_time}"
puts "RSI(5) latest value: #{rsi_results.first.rsi.round(4)}"

# Indicator metadata
puts "SMA symbol: #{TechnicalAnalysis::Sma.indicator_symbol}"
puts "EMA name: #{TechnicalAnalysis::Ema.indicator_name}"
puts "RSI min_data_size(5): #{TechnicalAnalysis::Rsi.min_data_size(period: 5)}"
