# frozen_string_literal: true

require 'i18n_country_translations_data'
require 'json'

# data_dir returns path to the directory of locale JSON files
dir = I18nCountryTranslationsData.data_dir
puts dir.end_with?('data') ? 'data_dir:ok' : "data_dir:unexpected:#{dir}"

# Read the English locale and look up known country codes
en_path = File.join(dir, 'en.json')
en = JSON.parse(File.read(en_path))
puts en['US']
puts en['DE']
puts en['JP']

# Read the German locale to confirm multi-locale support
de_path = File.join(dir, 'de.json')
de = JSON.parse(File.read(de_path))
puts de['DE']
puts de['JP']

# Count the number of locale JSON files available
locale_count = Dir.glob(File.join(dir, '*.json')).size
puts locale_count >= 100 ? "locales:#{locale_count}:ok" : "locales:#{locale_count}:unexpected"
