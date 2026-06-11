# Smoke: openweathermap — pure constant surface, no network
puts OpenWeatherMap::Constants::API_URL
puts OpenWeatherMap::Constants::UNITS.length
puts OpenWeatherMap::Constants::UNITS.sort.join(",")
puts OpenWeatherMap::Constants::LANGS.length
puts OpenWeatherMap::Constants::URLS[:current]
puts OpenWeatherMap::Constants::URLS[:forecast]
puts OpenWeatherMap::Constants::CONDITION_CODE['01d']
puts OpenWeatherMap::Constants::CONDITION_CODE['11d']
puts OpenWeatherMap::Exceptions::UnknownLang.superclass.name
