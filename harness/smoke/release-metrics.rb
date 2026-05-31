require_relative "lib/metrics"

puts Metrics.release_year(["12/25/2020", "Puppet Enterprise"])
puts Metrics.release_year(["01/01/2019", "FOSS"])
puts Metrics.release_year(["06/15/2018", "Puppet Enterprise"])
