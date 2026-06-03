require "google/cloud/translate/v2/translation"
require "google/cloud/translate/v2/detection"
require "google/cloud/translate/v2/language"
require "google/cloud/translate/v2/version"

puts Google::Cloud::Translate::V2::VERSION

# --- Language ---
lang = Google::Cloud::Translate::V2::Language.new("fr", "French")
puts lang.code
puts lang.name

lang2 = Google::Cloud::Translate::V2::Language.from_gapi({ "language" => "de", "name" => "German" })
puts lang2.code
puts lang2.name

# --- Translation: single with detected source language ---
gapi_t = { "translatedText" => "Bonjour le monde", "detectedSourceLanguage" => "en", "model" => "nmt" }
t = Google::Cloud::Translate::V2::Translation.from_gapi(gapi_t, "fr", "Hello world", nil)
puts t.text
puts t.origin
puts t.to
puts t.from
puts t.model
puts t.detected?

# Translation with explicit source (no detection)
gapi_t2 = { "translatedText" => "Hola mundo", "model" => "base" }
t2 = Google::Cloud::Translate::V2::Translation.from_gapi(gapi_t2, "es", "Hello world", "en")
puts t2.text
puts t2.from
puts t2.detected?

# Translation aliases
puts t.to_s
puts t.language
puts t.source

# Batch from_gapi_list
gapi_list = { "translations" => [
  { "translatedText" => "Guten Tag", "model" => "nmt" },
  { "translatedText" => "Auf Wiedersehen", "model" => "nmt" }
]}
batch = Google::Cloud::Translate::V2::Translation.from_gapi_list(gapi_list, ["Good day", "Goodbye"], "de", "en")
puts batch.size
puts batch[0].text
puts batch[1].text
puts batch[0].origin

# --- Detection ---
gapi_d = { "detections" => [
  [{ "language" => "fr", "confidence" => 0.98 }, { "language" => "es", "confidence" => 0.01 }]
]}
d = Google::Cloud::Translate::V2::Detection.from_gapi(gapi_d, ["Bonjour"])
puts d.text
puts d.language
puts d.confidence
puts d.results.size
puts d.results[1].language
puts d.results[1].confidence
