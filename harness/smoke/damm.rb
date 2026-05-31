# Damm check-digit algorithm smoke
puts Damm::TASQ[0][0]
puts Damm::TASQ[0][3]
puts Damm::TASQ[5][2]
puts Damm.generate("572")
puts Damm.valid?("5724")
puts Damm.valid?("5723")
puts Damm.generate("0")
puts Damm.valid?("00")
