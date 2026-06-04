require 'digest/sha1'
require 'uri'
require 'cgi'

# Stub external deps that require native extensions or complex gems
module Nokogiri; end
module Mail; end

# Prevent require 'nokogiri', 'mail', 'open-uri', 'email-spec' from
# raising LoadError by faking them as already-loaded
$LOADED_FEATURES.push('nokogiri.rb') unless $LOADED_FEATURES.include?('nokogiri.rb')
$LOADED_FEATURES.push('mail.rb') unless $LOADED_FEATURES.include?('mail.rb')
$LOADED_FEATURES.push('open-uri.rb') unless $LOADED_FEATURES.include?('open-uri.rb')

require 'mailinator'

# Test domain accessor defaults and assignment
puts Mailinator.domain
Mailinator.domain = "customdomain.com"
puts Mailinator.domain
Mailinator.reset_domain!
puts Mailinator.domain

# Test initialize + email formatting — plain name gets domain appended
m = Mailinator.new("testuser")
puts m.name
puts m.email

# Test initialize when name already contains @domain — kept as-is
m2 = Mailinator.new("hello@mailinator.com")
puts m2.name
puts m2.email

# Test URL generation methods
m3 = Mailinator.new("smoketest")
puts m3.inbox_url
puts m3.rss_url
puts m3.atom_url
puts m3.widget_url
puts m3.widget_url("300", "400")

# Test mostly_random produces a Mailinator with expected structure
r = Mailinator.mostly_random
puts r.email.end_with?("@mailinator.com")
puts r.name.length <= 25
