# schedule with even number of players — deterministic
schedule = RoundRobinTournament.schedule([1, 2, 3, 4])
puts schedule.length
schedule.each do |round|
  puts round.map { |pair| "#{pair[0]}v#{pair[1]}" }.join(",")
end
