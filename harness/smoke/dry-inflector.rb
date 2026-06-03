# frozen_string_literal: true

require "dry-inflector"

inflector = Dry::Inflector.new

# pluralize / singularize
puts inflector.pluralize("book")    # => books
puts inflector.pluralize("money")   # => money (uncountable)
puts inflector.singularize("books") # => book
puts inflector.singularize("mice")  # => mouse

# camelize / underscore (round-trip)
puts inflector.camelize("data_mapper")         # => DataMapper
puts inflector.camelize_lower("data_mapper")   # => dataMapper
puts inflector.underscore("DataMapper")        # => data_mapper
puts inflector.underscore("Dry::Inflector")    # => dry/inflector

# classify + tableize
puts inflector.classify("books")               # => Book
puts inflector.tableize("Book")                # => books

# dasherize + demodulize
puts inflector.dasherize("dry_inflector")      # => dry-inflector
puts inflector.demodulize("Dry::Inflector")    # => Inflector

# humanize
puts inflector.humanize("dry_inflector")       # => Dry inflector
puts inflector.humanize("author_id")           # => Author

# ordinalize
puts inflector.ordinalize(1)   # => 1st
puts inflector.ordinalize(2)   # => 2nd
puts inflector.ordinalize(3)   # => 3rd
puts inflector.ordinalize(11)  # => 11th
puts inflector.ordinalize(23)  # => 23rd

# foreign_key
puts inflector.foreign_key("Message")          # => message_id

# uncountable?
puts inflector.uncountable?("money")           # => true
puts inflector.uncountable?("book")            # => false
