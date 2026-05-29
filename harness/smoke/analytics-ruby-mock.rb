require_relative "lib/analytics_ruby_mock"
AnalyticsRuby.track(event: "page_view", user_id: "u1")
AnalyticsRuby.track(event: "click", user_id: "u2")
puts AnalyticsRuby.tracked_events.inspect
AnalyticsRuby.identify(user_id: "u1", traits: { name: "Alice" })
puts AnalyticsRuby.identify_calls.length
AnalyticsRuby.alias(previous_id: "anon", user_id: "u1")
puts AnalyticsRuby.alias_calls.length
AnalyticsRuby.clear
puts AnalyticsRuby.tracked_events.inspect
