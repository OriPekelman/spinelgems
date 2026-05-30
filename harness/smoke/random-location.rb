puts RandomLocation::METERS_IN_DEGREE
puts RandomLocation::METERS_IN_DEGREE.class
puts RandomLocation::METERS_IN_DEGREE == 111_300
# Pure arithmetic using the constant
radius = 1000.0 / RandomLocation::METERS_IN_DEGREE
puts radius.round(10)
puts (500.0 / RandomLocation::METERS_IN_DEGREE).round(12)
