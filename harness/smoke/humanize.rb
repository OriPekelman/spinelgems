require 'humanize-number'

# Small numbers - returned as-is
puts HumanizeNumber.humanize(0)
puts HumanizeNumber.humanize(42)
puts HumanizeNumber.humanize(999)

# Thousands
puts HumanizeNumber.humanize(1000)
puts HumanizeNumber.humanize(1500)
puts HumanizeNumber.humanize(42_000)
puts HumanizeNumber.humanize(999_999)

# Millions
puts HumanizeNumber.humanize(1_000_000)
puts HumanizeNumber.humanize(2_500_000)
puts HumanizeNumber.humanize(123_456_789)

# Billions
puts HumanizeNumber.humanize(1_000_000_000)
puts HumanizeNumber.humanize(7_800_000_000)

# Negative numbers
puts HumanizeNumber.humanize(-5000)
puts HumanizeNumber.humanize(-1_200_000)

# Non-numeric passthrough
puts HumanizeNumber.humanize("hello")
