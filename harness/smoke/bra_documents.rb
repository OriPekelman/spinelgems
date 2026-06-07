# frozen_string_literal: true

require 'bra_documents'

# CPF: generate with known person_number so output is deterministic
cpf = BraDocuments::CPFGenerator.generate(person_number: '123456789')
puts "CPF raw: #{cpf}"

cpf_fmt = BraDocuments::CPFGenerator.generate(person_number: '123456789', formatted: true)
puts "CPF formatted: #{cpf_fmt}"

# Validate known-good CPF
puts "CPF valid? #{BraDocuments::CPFGenerator.valid_verification_digit?(document: cpf)}"
puts "CPF valid (formatted)? #{BraDocuments::CPFGenerator.valid_verification_digit?(document: cpf_fmt)}"
# Validate known-bad CPF (all same digit is rejected by matcher)
puts "CPF all-same invalid? #{BraDocuments::CPFGenerator.valid_verification_digit?(document: '11111111111')}"

# Formatter: strip formatting
raw = BraDocuments::Formatter.raw('860.272.658-92', kind: :cpf)
puts "Formatter.raw CPF: #{raw}"
formatted = BraDocuments::Formatter.format('86027265892', as: :cpf)
puts "Formatter.format CPF: #{formatted}"

# CNPJ: generate with known company_number and matrix
cnpj = BraDocuments::CNPJGenerator.generate(company_number: '29432530', matrix_subsidiary_number: '0001')
puts "CNPJ raw: #{cnpj}"
cnpj_fmt = BraDocuments::CNPJGenerator.generate(company_number: '29432530', matrix_subsidiary_number: '0001', formatted: true)
puts "CNPJ formatted: #{cnpj_fmt}"

# Validate known-good CNPJ
puts "CNPJ valid? #{BraDocuments::CNPJGenerator.valid_verification_digit?(document: cnpj)}"
puts "CNPJ valid (formatted)? #{BraDocuments::CNPJGenerator.valid_verification_digit?(document: cnpj_fmt)}"

# Matcher
puts "Matcher CPF raw match? #{BraDocuments::Matcher.match?('12345678987', kind: :cpf, mode: :raw)}"
puts "Matcher CPF all-same? #{BraDocuments::Matcher.match?('11111111111', kind: :cpf, mode: :raw)}"
puts "Matcher CPF formatted? #{BraDocuments::Matcher.match?('123.456.789-87', kind: :cpf, mode: :formatted)}"
puts "Matcher CNPJ raw? #{BraDocuments::Matcher.match?('29432530000190', kind: :cnpj, mode: :raw)}"
puts "Matcher CNPJ formatted? #{BraDocuments::Matcher.match?('29.432.530/0001-90', kind: :cnpj, mode: :formatted)}"
