# Constants defined directly in glicko2.rb
puts Glicko2::DEFAULT_VOLATILITY
puts Glicko2::DEFAULT_GLICKO_RATING
puts Glicko2::DEFAULT_GLICKO_RATING_DEVIATION
puts Glicko2::TOLERANCE

# Util.ranks_to_score: win, draw, loss
puts Glicko2::Util.ranks_to_score(1, 2)
puts Glicko2::Util.ranks_to_score(2, 2)
puts Glicko2::Util.ranks_to_score(3, 1)
