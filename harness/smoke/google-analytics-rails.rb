# smoke: google-analytics-rails
# Exercises core GA tracker config, event construction, and JS rendering.
# The railtie is guarded by rescue LoadError so it silently skips without Rails.

require 'google-analytics-rails'

# 1. Tracker configuration
GoogleAnalytics.tracker = "UA-12345-6"
puts "tracker=#{GoogleAnalytics.tracker}"
puts "valid_tracker=#{GoogleAnalytics.valid_tracker?}"

# 2. max_custom_indices (regular vs premium account)
puts "max_indices_regular=#{GoogleAnalytics.max_custom_indices}"
GoogleAnalytics.premium_account = true
puts "max_indices_premium=#{GoogleAnalytics.max_custom_indices}"
GoogleAnalytics.premium_account = false

# 3. SetupAnalytics event rendering
setup = GoogleAnalytics::Events::SetupAnalytics.new("UA-12345-6")
renderer = GoogleAnalytics::EventRenderer.new(setup, nil)
puts "setup=#{renderer.to_s}"

# 4. TrackPageview
pv = GoogleAnalytics::Events::TrackPageview.new
r2 = GoogleAnalytics::EventRenderer.new(pv, nil)
puts "pageview=#{r2.to_s}"

# 5. TrackEvent with label/value
te = GoogleAnalytics::Events::TrackEvent.new("Video", "Play", "homepage", 1)
r3 = GoogleAnalytics::EventRenderer.new(te, nil)
puts "track_event=#{r3.to_s}"

# 6. SetCustomDimension
cd = GoogleAnalytics::Events::SetCustomDimension.new(3, "subscriber")
r4 = GoogleAnalytics::EventRenderer.new(cd, nil)
puts "custom_dim=#{r4.to_s}"

# 7. AnonymizeIp
anon = GoogleAnalytics::Events::AnonymizeIp.new
r5 = GoogleAnalytics::EventRenderer.new(anon, nil)
puts "anonymize=#{r5.to_s}"

# 8. Ecommerce AddTransaction
txn = GoogleAnalytics::Events::Ecommerce::AddTransaction.new("ORD-1", "MyShop", "19.99", "1.50", "3.00")
r6 = GoogleAnalytics::EventRenderer.new(txn, nil)
puts "ecommerce_txn=#{r6.to_s}"

# 9. EventCollection size check
coll = GoogleAnalytics::EventCollection.new
coll << GoogleAnalytics::Events::TrackPageview.new
coll << GoogleAnalytics::Events::AnonymizeIp.new
puts "collection_size=#{coll.size}"
