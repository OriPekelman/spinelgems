# Rank.compare: ascending order
puts Rank.compare({score: 5}, {score: 10}, :score)        # -1
puts Rank.compare({score: 10}, {score: 5}, :score)         # 1
puts Rank.compare({score: 7}, {score: 7}, :score)          # 0

# Rank.compare: descending order
puts Rank.compare({score: 5}, {score: 10}, [:score, :desc])  # 1
puts Rank.compare({score: 10}, {score: 5}, [:score, :desc])  # -1

# Rank.add: adds :rank key by sorting ascending
items = [{score: 30}, {score: 10}, {score: 20}]
ranked = Rank.add(items, :score)
ranked.each { |r| puts "#{r[:score]}:#{r[:rank]}" }

# Rank.add: ties share the same rank
items2 = [{val: 5}, {val: 5}, {val: 9}]
ranked2 = Rank.add(items2, :val)
ranked2.each { |r| puts "#{r[:val]}:#{r[:rank]}" }
