require_relative "lib/stigg/version"
require_relative "lib/stigg/generated/operations"
puts Stigg::VERSION
puts Stigg::Fragment::CouponFragment.include?("fragment CouponFragment on Coupon")
puts Stigg::Fragment::PriceTierFragment.include?("fragment PriceTierFragment on PriceTier")
puts Stigg::Fragment::TotalPriceFragment.include?("fragment TotalPriceFragment on CustomerSubscriptionTotalPrice")
puts Stigg::Fragment.constants.include?(:CouponFragment)
