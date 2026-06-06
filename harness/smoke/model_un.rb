require 'model_un'

# US State abbreviation -> full name
puts ModelUN.convert_state_abbreviation('CA')   # => California
puts ModelUN.convert_state_abbreviation('NY')   # => New York
puts ModelUN.convert_state_abbreviation('TX')   # => Texas

# US State full name -> abbreviation
puts ModelUN.convert_state_name('California')   # => CA
puts ModelUN.convert_state_name('New York')     # => NY

# NATO country abbreviation -> full name
puts ModelUN.convert_nato_country_abbr('USA')   # => United States Of America
puts ModelUN.convert_nato_country_abbr('FRA')   # => France
puts ModelUN.convert_nato_country_abbr('DEU')   # => Germany

# NATO country name -> abbreviation
puts ModelUN.convert_nato_country_name('France')   # => FRA

# Generic convert dispatch: 2-char -> state, 3-char -> nato country, else name
puts ModelUN.convert('CA')       # => California
puts ModelUN.convert('USA')      # => United States Of America
puts ModelUN.convert('Texas')    # => TX
