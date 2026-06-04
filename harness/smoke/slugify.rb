# Smoke: slugify-eobrien gem — Slugifyeobrien#to_slug string conversion
class Slugger
  include Slugifyeobrien
  public :to_slug
end

s = Slugger.new

puts s.to_slug("Hello World")
puts s.to_slug("it's a test")
puts s.to_slug("foo & bar @ baz")
puts s.to_slug("  leading and trailing  ")
puts s.to_slug("multiple---dashes")
puts s.to_slug("special!@#chars")
