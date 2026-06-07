# Smoke test for subdomain_locale
# Tests the core Mapping class directly (Rails-free), avoiding I18n/ActiveSupport deps.

# Stub String#presence (ActiveSupport) so mapping.rb works standalone
class String
  def presence
    empty? ? nil : self
  end
end

# The top-level require only loads railtie if Rails is defined — since Rails is NOT
# defined here, we explicitly require the mapping sub-file directly via the load path.
require 'subdomain_locale/mapping'

# Build a mapping: subdomain -> locale
mapping = SubdomainLocale::Mapping.new(
  "en"  => :en,
  "fr"  => :fr,
  "de"  => :de,
  ""    => :en
)

# locale_for: subdomain -> locale string
puts mapping.locale_for("fr")        # => "fr"
puts mapping.locale_for("de")        # => "de"
puts mapping.locale_for("en")        # => "en"
puts mapping.locale_for("unknown")   # => "unknown" (falls back to subdomain itself)
puts mapping.locale_for("")          # => "en"

# subdomain_for: locale -> subdomain
puts mapping.subdomain_for("fr")     # => "fr"
puts mapping.subdomain_for("de")     # => "de"
puts mapping.subdomain_for("en")     # => "" (mapped to empty-string subdomain)
puts mapping.subdomain_for("xx")     # => "xx" (not in map, returns locale itself)
puts mapping.subdomain_for(nil)      # => false (nil locale)
