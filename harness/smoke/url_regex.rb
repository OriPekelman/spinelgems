rx = UrlRegex.get(scheme_required: true, mode: :validation)
puts rx.class

rx2 = UrlRegex.get(scheme_required: false, mode: :validation)
puts rx2.class

rx3 = UrlRegex.get(scheme_required: true, mode: :parsing)
puts rx3.class

puts "https://www.example.com" =~ rx ? "match" : "no match"
puts "not-a-url" =~ rx ? "match" : "no match"
puts "ftp://example.org" =~ rx ? "match" : "no match"
