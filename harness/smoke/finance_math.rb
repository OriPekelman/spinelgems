loan = FinanceMath::Loan.new(nominal_rate: 5.0, duration: 120, amount: 100000.0)
puts loan.duration.to_i
puts loan.amount.to_i
puts loan.nominal_rate
puts loan.monthly_rate.round(8)
puts loan.principal.round(4)
puts loan.pmt.round(4)
puts loan.apr.round(4)
