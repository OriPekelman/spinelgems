# frozen_string_literal: true

# Smoke test for find-subscriptions gem
# Exercises: PayeeNormalizer, Transaction struct, RepeatCharges detector

require 'find_subscriptions'
require 'bigdecimal'
require 'date'

# --- PayeeNormalizer: fallback normalization ---
norm = FindSubscriptions::PayeeNormalizer.new(rules: [])

puts norm.normalize("NETFLIX.COM *MONTHLY")       # => "netflix com  monthly"
puts norm.normalize("SPOTIFY USA LLC 800-555-9999") # => "spotify usa llc 800 555 9999"
puts norm.normalize("  AMZ*Prime  ")              # => "amz prime"

# --- PayeeNormalizer: rule-based normalization ---
rule = FindSubscriptions::PayeeNormalizer::Rule.new(
  name: "Netflix",
  normalized: "netflix",
  regexes: [/netflix/i]
)
norm2 = FindSubscriptions::PayeeNormalizer.new(rules: [rule])

puts norm2.normalize("NETFLIX.COM *MONTHLY")   # => "netflix"
puts norm2.display_name("NETFLIX.COM *MONTHLY") # => "Netflix"
puts norm2.display_name("SPOTIFY USA")          # => (nil printed as empty)
puts norm2.known_payee_key?("netflix")           # => true
puts norm2.known_payee_key?("spotify")           # => false

# --- Transaction struct ---
t1 = FindSubscriptions::Transaction.new(
  date: Date.new(2024, 1, 15),
  payee: "NETFLIX.COM",
  amount: BigDecimal("15.99"),
  raw: { "desc" => "NETFLIX.COM", "amt" => "15.99" }
)
puts t1.payee   # => NETFLIX.COM
puts t1.amount  # => 0.1599e2

# --- RepeatCharges: detect monthly subscriptions ---
txns = [
  FindSubscriptions::Transaction.new(date: Date.new(2024, 1, 15), payee: "NETFLIX", amount: BigDecimal("15.99"), raw: {}),
  FindSubscriptions::Transaction.new(date: Date.new(2024, 2, 15), payee: "NETFLIX", amount: BigDecimal("15.99"), raw: {}),
  FindSubscriptions::Transaction.new(date: Date.new(2024, 3, 15), payee: "NETFLIX", amount: BigDecimal("15.99"), raw: {}),
  FindSubscriptions::Transaction.new(date: Date.new(2024, 1, 20), payee: "SPOTIFY", amount: BigDecimal("9.99"), raw: {}),
  FindSubscriptions::Transaction.new(date: Date.new(2024, 2, 20), payee: "SPOTIFY", amount: BigDecimal("9.99"), raw: {}),
  # one-off charge — should NOT be detected
  FindSubscriptions::Transaction.new(date: Date.new(2024, 3, 1), payee: "AMAZON", amount: BigDecimal("42.00"), raw: {}),
]

detector = FindSubscriptions::Detectors::RepeatCharges.new(
  payee_normalizer: FindSubscriptions::PayeeNormalizer.new(rules: []),
  min_occurrences: 2,
  min_month_gap_days: 20,
  max_month_gap_days: 40
)

candidates = detector.detect(txns).sort_by { |c| c.payee_key }
puts candidates.size  # => 2
candidates.each do |c|
  puts "#{c.payee_key} #{c.amount} #{c.count}"
end
