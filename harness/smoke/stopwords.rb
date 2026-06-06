require 'stopwords'

# Patch File.exists? removed in Ruby 3.2 (gem uses it internally)
class File
  class << self
    alias_method :exists?, :exist? unless respond_to?(:exists?)
  end
end

# 1. Basic Filter with a custom stopword list
custom_list = %w[the a an is are was were be been being]
filter = Stopwords::Filter.new(custom_list)

words = %w[The quick brown fox is a lazy dog]
filtered = filter.filter(words)
puts filtered.join(' ')
# => quick brown fox lazy dog  (case-insensitive removes The, is, a)

# 2. stopword? predicate
puts filter.stopword?('the')   # => true
puts filter.stopword?('The')   # => true
puts filter.stopword?('fox')   # => false

# 3. Snowball::Filter with English locale
sf = Stopwords::Snowball::Filter.new('en')
sentence = %w[I love programming and it is great fun]
result = sf.filter(sentence)
puts result.join(' ')
# stopwords removed; survivors: love programming great fun

# 4. Snowball::Filter stopword? check
puts sf.stopword?('the')   # => true
puts sf.stopword?('ruby')  # => false
