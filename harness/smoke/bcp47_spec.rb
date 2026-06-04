# frozen_string_literal: true
require 'bcp47_spec'

# 1. valid? — basic language tags
puts BCP47.valid?('en')            # true
puts BCP47.valid?('zh')            # true
puts BCP47.valid?('not valid!!!')  # false
puts BCP47.valid?('')              # false

# 2. parse — simple tag
tag = BCP47.parse('en')
puts tag.language    # en
puts tag.script.nil? # true
puts tag.region.nil? # true

# 3. parse — language + region
tag = BCP47.parse('en-US')
puts tag.language  # en
puts tag.region    # US

# 4. parse — language + script + region
tag = BCP47.parse('zh-Hans-CN')
puts tag.language  # zh
puts tag.script    # Hans
puts tag.region    # CN

# 5. parse — with variant
tag = BCP47.parse('sl-rozaj-biske')
puts tag.language            # sl
puts tag.variants.sort.inspect  # ["biske", "rozaj"]

# 6. parse — with private use
tag = BCP47.parse('de-CH-x-phonebk')
puts tag.language  # de
puts tag.region    # CH
puts tag.private.inspect  # ["phonebk"]

# 7. InvalidLanguageTag raised on bad input
begin
  BCP47.parse('not valid!!!')
  puts 'no error raised'
rescue BCP47::InvalidLanguageTag => e
  puts 'InvalidLanguageTag raised'
end

# 8. valid? with extension subtag
puts BCP47.valid?('en-u-attr')   # true
puts BCP47.valid?('zh-t-und-cyrl')  # true
