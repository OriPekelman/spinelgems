require 'isbn/tools'

# cleanup: strip hyphens, upcase X
puts ISBN_Tools.cleanup("0-8436-1072-7")          # => 0843610727
puts ISBN_Tools.cleanup("0-8436-1072-x")          # => 084361072X

# is_valid_isbn10?
puts ISBN_Tools.is_valid_isbn10?("0843610727")    # => true
puts ISBN_Tools.is_valid_isbn10?("1-56619-909-3") # => true
puts ISBN_Tools.is_valid_isbn10?("0843610720")    # => false (bad check digit)

# is_valid_isbn13?
puts ISBN_Tools.is_valid_isbn13?("9781566199094") # => true
puts ISBN_Tools.is_valid_isbn13?("9781566199090") # => false

# compute check digits
puts ISBN_Tools.compute_isbn10_check_digit("084361072") # => 7
puts ISBN_Tools.compute_isbn13_check_digit("978156619909") # => 4

# isbn10 <-> isbn13 conversion
puts ISBN_Tools.isbn10_to_isbn13("1-56619-909-3")  # => 9781566199094
puts ISBN_Tools.isbn13_to_isbn10("9781566199094")  # => 1566199093

# hyphenation (groups 0,1,2)
puts ISBN_Tools.hyphenate_isbn10("0843610727").inspect   # => "0-84361-072-7" or similar
puts ISBN_Tools.hyphenate_isbn13("9781566199094").inspect # => hyphenated or nil
