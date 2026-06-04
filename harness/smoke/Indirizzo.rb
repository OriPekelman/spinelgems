require 'indirizzo'

# Exercise Indirizzo::Address parsing with concrete US addresses

# 1. Basic street address with city, state, ZIP
addr1 = Indirizzo::Address.new("1600 Pennsylvania Ave NW, Washington, DC 20500")
puts "number=#{addr1.number}"
puts "street_first=#{addr1.street.first}"
puts "state=#{addr1.state}"
puts "zip=#{addr1.zip}"

# 2. Address with full state name (gets normalized to abbreviation)
addr2 = Indirizzo::Address.new("742 Evergreen Terrace, Springfield, Illinois 62701")
puts "number2=#{addr2.number}"
puts "state2=#{addr2.state}"
puts "zip2=#{addr2.zip}"

# 3. intersection? and po_box? predicates
plain   = Indirizzo::Address.new("500 Main St, Anytown, CA 90210")
inter   = Indirizzo::Address.new("Main St at Broadway, New York, NY")
po      = Indirizzo::Address.new("PO Box 1234, Dallas, TX 75201")
puts "plain_intersection=#{plain.intersection?}"
puts "is_intersection=#{inter.intersection?}"
puts "is_po_box=#{po.po_box?}"

# 4. clean method strips noise characters
addr3 = Indirizzo::Address.new("  123 Maple!!! Street, Portland, OR 97201  ")
puts "clean_number=#{addr3.number}"
puts "clean_state=#{addr3.state}"
