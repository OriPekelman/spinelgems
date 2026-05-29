# tradsim smoke: traditional<->simplified conversion
# Convert some traditional Chinese chars to simplified
trad_text = "愛忳氣地山"
sim_result = Tradsim.to_sim(trad_text)
puts sim_result

# Convert simplified back to traditional
sim_text = "爱忆气地山"
trad_result = Tradsim.to_trad(sim_text)
puts trad_result

# Guess the script type
puts Tradsim.guess(trad_text).to_s
puts Tradsim.guess(sim_text).to_s
