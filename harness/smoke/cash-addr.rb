# Known BCH address pairs (legacy <-> cashaddr), from Bitcoin Cash spec
LEGACY_P2PKH   = '1BpEi6DfDAUFd153wiGrvkiKW1BCTNNgq5'
CASHADDR_P2PKH = 'bitcoincash:qpm2qsznhks23z7629mms6s4cwef74vcwvy22gdx6a'

LEGACY_P2SH  = '3CWFddi6m4ndiGyKqzYvsFYagqDLPVMTDC'
CASHADDR_P2SH = 'bitcoincash:ppm2qsznhks23z7629mms6s4cwef74vcwvn0h829pq'

# Convert legacy -> cashaddr
puts CashAddr::Converter.to_cash_address(LEGACY_P2PKH)
puts CashAddr::Converter.to_cash_address(LEGACY_P2SH)

# Convert cashaddr -> legacy
puts CashAddr::Converter.to_legacy_address(CASHADDR_P2PKH)
puts CashAddr::Converter.to_legacy_address(CASHADDR_P2SH)

# Validation
puts CashAddr::Converter.is_valid?(LEGACY_P2PKH)
puts CashAddr::Converter.is_valid?(CASHADDR_P2PKH)
puts CashAddr::Converter.is_valid?('not-an-address')

# Display address (strips the bitcoincash: prefix)
puts CashAddr::Converter.display_address(LEGACY_P2PKH)
