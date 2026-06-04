# frozen_string_literal: true

require 'find_subscriptions'
require 'bigdecimal'
require 'date'

# --- PayeeNormalizer: fallback_normalize ---
normalizer = FindSubscriptions::PayeeNormalizer.new(rules: [])
puts normalizer.normalize('NETFLIX.COM *12345')
puts normalizer.normalize('  Spotify   AB  ')

# --- PayeeNormalizer: with explicit rules ---
rule = FindSubscriptions::PayeeNormalizer::Rule.new(
  name: 'Netflix',
  normalized: 'netflix',
  regexes: [/netflix/i]
)
n2 = FindSubscriptions::PayeeNormalizer.new(rules: [rule])
puts n2.normalize('NETFLIX.COM')
puts n2.display_name('Netflix monthly')
puts n2.known_payee_key?('netflix')
puts n2.known_payee_key?('hulu')

# --- Transaction struct ---
t = FindSubscriptions::Transaction.new(
  date: Date.new(2024, 1, 15),
  payee: 'NETFLIX.COM',
  amount: BigDecimal('15.99'),
  raw: {}
)
puts t.payee
puts t.amount.to_s('F')
puts t.date.to_s

# --- RepeatCharges: detect subscription pattern ---
pn = FindSubscriptions::PayeeNormalizer.new(rules: [])
detector = FindSubscriptions::Detectors::RepeatCharges.new(
  payee_normalizer: pn,
  min_occurrences: 2,
  min_month_gap_days: 25,
  max_month_gap_days: 40
)

txs = [
  FindSubscriptions::Transaction.new(date: Date.new(2024, 1, 1), payee: 'spotify ab', amount: BigDecimal('9.99'), raw: {}),
  FindSubscriptions::Transaction.new(date: Date.new(2024, 2, 1), payee: 'spotify ab', amount: BigDecimal('9.99'), raw: {}),
  FindSubscriptions::Transaction.new(date: Date.new(2024, 3, 3), payee: 'spotify ab', amount: BigDecimal('9.99'), raw: {}),
  FindSubscriptions::Transaction.new(date: Date.new(2024, 1, 5), payee: 'coffee shop', amount: BigDecimal('4.50'), raw: {}),
  # incoming / refund — should be ignored
  FindSubscriptions::Transaction.new(date: Date.new(2024, 1, 10), payee: 'refund', amount: BigDecimal('-5.00'), raw: {}),
]

candidates = detector.detect(txs)
puts candidates.size
c = candidates.first
puts c.payee_key
puts c.amount.to_s('F')
puts c.count
puts c.since.to_s
puts c.until.to_s

# --- SchemaRegistry: register and detect ---
reg = FindSubscriptions::SchemaRegistry.new
schema = FindSubscriptions::CsvSchema.new(
  required_headers: ['Date', 'Description', 'Amount'],
  amount_key: 'Amount',
  direction: ->(row, amt) { amt >= 0 ? :debit : :credit },
  mapping: ->(row, signed) {
    FindSubscriptions::Transaction.new(
      date: Date.parse(row['Date']),
      payee: row['Description'],
      amount: BigDecimal(signed.to_s),
      raw: row
    )
  }
)
reg.register('generic', schema)
puts reg.schemas.keys.first
puts reg.detect_for(['Date', 'Description', 'Amount']).class
puts reg.detect_for(['Foo', 'Bar']).nil?
