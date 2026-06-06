require 'open_weather'

# Test 1: VERSION constant
puts OpenWeather::VERSION

# Test 2: OpenWeather::Base.new strips invalid options and keeps valid ones
# We inspect via attr_reader :options
b = OpenWeather::Base.new('http://example.com', { id: 123, lang: 'en', bogus: 'drop', foo: 'bar' })
opts = b.options
puts opts[:id]
puts opts[:lang]
puts opts.key?(:bogus)
puts opts.key?(:foo)

# Test 3: city + country are merged into :q by extract_options!
b2 = OpenWeather::Base.new('http://example.com', { city: 'London', country: 'GB', units: 'metric' })
opts2 = b2.options
puts opts2[:q]
puts opts2.key?(:city)
puts opts2.key?(:country)
puts opts2[:units]

# Test 4: SeveralCitiesClassMethods.encode_array (accessed via Current which extends it)
# encode_array is private, exercise it indirectly through cities URL construction
# by checking that the Current class has the right default URL
c = OpenWeather::Current.new({ id: 42, lang: 'fr' })
puts c.url
puts c.options[:id]
puts c.options[:lang]

# Test 5: Forecast subclass sets its own URL
f = OpenWeather::Forecast.new({ id: 99, units: 'imperial' })
puts f.url
puts f.options[:units]

# Test 6: success? returns false by default (status is false, not 200)
puts b.success?
