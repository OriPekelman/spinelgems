require_relative "lib/google/cloud/translate/v2/version"
require_relative "lib/google/cloud/translate/v2/language"

puts Google::Cloud::Translate::V2::VERSION

lang = Google::Cloud::Translate::V2::Language.new("fr", "French")
puts lang.code
puts lang.name

lang2 = Google::Cloud::Translate::V2::Language.from_gapi({ "language" => "de", "name" => "German" })
puts lang2.code
puts lang2.name
