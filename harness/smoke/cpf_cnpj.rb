# Smoke test for cpf_cnpj gem - CPF/CNPJ Brazilian document validation
puts CPF.valid?("111.444.777-35")
puts CPF.valid?("111.444.777-36")
puts CPF.valid?("00000000000")
puts CPF.format("11144477735")
puts CPF.new("111.444.777-35").stripped
puts CNPJ.valid?("11.222.333/0001-81")
puts CNPJ.valid?("11.222.333/0001-82")
puts CNPJ.format("11222333000181")
