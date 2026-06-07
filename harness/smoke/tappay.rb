# frozen_string_literal: true
require 'tappay'

# 1. Version constant
puts TapPay::VERSION

# 2. Default mode
puts TapPay.mode.inspect

# 3. Configure via setup block
TapPay.setup do |config|
  config.mode        = :sandbox
  config.partner_key = 'test' + '_partner_key'
end

puts TapPay.mode.inspect
puts TapPay.partner_key

# 4. Validate mode change to production
TapPay.mode = :production
puts TapPay.mode.inspect

# 5. Invalid mode raises ArgumentError
begin
  TapPay.mode = :invalid
  puts "no error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 6. APIResources URL generation in sandbox mode
TapPay.mode = :sandbox
puts TapPay::Payment.resource_url('pay_by_prime')
puts TapPay::Payment.resource_url('pay_by_token')

# 7. APIResources URL generation in production mode
TapPay.mode = :production
puts TapPay::Card.resource_url('bind')
puts TapPay::Transaction.resource_url('trade_history')

# 8. VALID_MODES constant
puts TapPay::VALID_MODES.inspect

# 9. APIResources constants
puts TapPay::APIResources::CARD.inspect
puts TapPay::APIResources::PAYMENT.inspect
puts TapPay::APIResources::TRANSACTION.inspect

# 10. class_name helpers
puts TapPay::Payment.class_name
puts TapPay::Card.class_name
puts TapPay::Transaction.class_name
