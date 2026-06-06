require 'validiso'

# Exercise Validiso::Countries — ISO-3166 country lookups by code, alpha2, alpha3

# find_by_code: numeric country calling code (stored as string)
result_code = Validiso::Countries.find_code('376')
puts result_code['name']        # Andorra
puts result_code['alpha2']      # AD
puts result_code['alpha3']      # AND
puts result_code['continent']   # Europe

# find_alpha2: ISO 3166-1 alpha-2 code
result_a2 = Validiso::Countries.find_alpha2('US')
puts result_a2['name']          # United States
puts result_a2['country_code']  # 1
puts result_a2['alpha3']        # USA

# find_alpha3: ISO 3166-1 alpha-3 code
result_a3 = Validiso::Countries.find_alpha3('DEU')
puts result_a3['name']          # Germany
puts result_a3['alpha2']        # DE

# missing lookup returns nil
puts Validiso::Countries.find_code('99999').inspect   # nil
puts Validiso::Countries.find_alpha2('XX').inspect    # nil
