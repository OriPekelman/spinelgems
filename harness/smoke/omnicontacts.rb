puts OmniContacts::VERSION
puts OmniContacts::MOUNT_PATH

require "omnicontacts/parse_utils"

extend OmniContacts::ParseUtils

puts normalize_name("  hello   world  ")
puts full_name("John", "Doe")
puts full_name("John", nil)
puts full_name(nil, "Doe")
puts image_url_from_email("user@gmail.com").to_s
puts image_url_from_email("user@yahoo.com").to_s
puts image_url_from_email(nil).inspect
