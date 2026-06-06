# frozen_string_literal: true
# Smoke for rails_cursor_pagination – exercises Cursor encode/decode
# which is the core serialization logic used by all paginators.

require 'json'
require 'rails_cursor_pagination'

# 1. Simple ID-only cursor (the most common case)
cursor_id = RailsCursorPagination::Cursor.new(id: 42)
encoded_id = cursor_id.encode
puts "id cursor encoded: #{encoded_id}"

decoded_id = RailsCursorPagination::Cursor.decode(encoded_string: encoded_id, order_field: :id)
puts "id cursor decoded id: #{decoded_id.id}"
puts "id cursor order_field_value: #{decoded_id.order_field_value.inspect}"

# 2. Cursor with a custom order field (e.g. ordering by :author)
cursor_author = RailsCursorPagination::Cursor.new(id: 7, order_field: :author, order_field_value: 'Jane')
encoded_author = cursor_author.encode
puts "author cursor encoded: #{encoded_author}"

decoded_author = RailsCursorPagination::Cursor.decode(encoded_string: encoded_author, order_field: :author)
puts "author cursor decoded id: #{decoded_author.id}"
puts "author cursor order_field_value: #{decoded_author.order_field_value}"

# 3. Verify round-trip correctness with the example from the README
# The README states cursor for id=2 is "Mg=="
readme_cursor = RailsCursorPagination::Cursor.decode(encoded_string: 'Mg==', order_field: :id)
puts "readme id-2 cursor decoded: #{readme_cursor.id}"

# 4. Verify the example compound cursor from the README: ['Jane', 4] → "WyJKYW5lIiw0XQ=="
readme_compound = RailsCursorPagination::Cursor.decode(encoded_string: 'WyJKYW5lIiw0XQ==', order_field: :author)
puts "readme compound id: #{readme_compound.id}"
puts "readme compound order_field_value: #{readme_compound.order_field_value}"

# 5. Test error handling for an invalid cursor
begin
  RailsCursorPagination::Cursor.decode(encoded_string: 'not-valid-base64!!!', order_field: :id)
  puts "expected error not raised"
rescue RailsCursorPagination::InvalidCursorError => e
  puts "invalid cursor error: #{e.class}"
end

# 6. Configuration: default_page_size
puts "default_page_size: #{RailsCursorPagination::Configuration.instance.default_page_size}"
RailsCursorPagination.configure { |c| c.default_page_size = 25 }
puts "configured_page_size: #{RailsCursorPagination::Configuration.instance.default_page_size}"
RailsCursorPagination::Configuration.instance.reset!
puts "reset_page_size: #{RailsCursorPagination::Configuration.instance.default_page_size}"
