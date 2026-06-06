# frozen_string_literal: true
require 'finance_rb'

# Finance::Calculations.npv — Net Present Value
# exercises the core discount loop: sum(value / (1+rate)^i)
npv1 = Finance::Calculations.npv(0.1, [-1000, 100, 100, 100])
puts "npv1: #{npv1.round(4)}"

npv2 = Finance::Calculations.npv(0.05, [0, 100, 200])
puts "npv2: #{npv2.round(4)}"

# Finance::Loan#pmt — periodic payment (pure float arithmetic)
# nominal_rate=0.1 -> monthly_rate=0.1/12; duration=12; amount=1000; ptype=:end -> 0.0
loan = Finance::Loan.new(nominal_rate: 0.1, duration: 12, amount: 1000, ptype: :end)
puts "pmt: #{loan.pmt.round(6)}"
