require 'rack-google_analytics'

# Build a minimal fake Rack app that returns an HTML body
html_body = "<html><head></head><body><h1>Hello</h1></body></html>"

fake_app = lambda do |env|
  [200, {"Content-Type" => "text/html", "Content-Length" => html_body.length.to_s}, [html_body]]
end

# Test 1: basic tracking code injection with a UA property ID
ga = Rack::GoogleAnalytics.new(fake_app, web_property_id: "UA-12345-1")
status, headers, response = ga.call({})
body = response.first
puts status
puts headers["Content-Type"]
puts body.include?("UA-12345-1") ? "has_tracking_id" : "missing_tracking_id"
puts body.include?("pageTracker") ? "has_pageTracker" : "missing_pageTracker"
puts body.include?("</body>") ? "has_closing_body" : "missing_closing_body"
puts body.include?("_trackPageview") ? "has_trackPageview" : "missing_trackPageview"

# Test 2: with domain name option
ga2 = Rack::GoogleAnalytics.new(fake_app, web_property_id: "UA-99999-2", domain_name: "example.com", prefix: "my_")
_, _, resp2 = ga2.call({})
body2 = resp2.first
puts body2.include?("example.com") ? "has_domain" : "missing_domain"
puts body2.include?("my_pageTracker") ? "has_prefix" : "missing_prefix"

# Test 3: with multiple_top_level_domains option
ga3 = Rack::GoogleAnalytics.new(fake_app, web_property_id: "UA-77777-3", multiple_top_level_domains: true)
_, _, resp3 = ga3.call({})
body3 = resp3.first
puts body3.include?("_setAllowLinker") ? "has_allow_linker" : "missing_allow_linker"
puts body3.include?("_setDomainName(\"none\")") ? "has_domain_none" : "missing_domain_none"

# Test 4: non-HTML content type should NOT inject tracking code
fake_json_app = lambda do |env|
  [200, {"Content-Type" => "application/json", "Content-Length" => "2"}, ["{}"]]
end
ga4 = Rack::GoogleAnalytics.new(fake_json_app, web_property_id: "UA-88888-4")
_, _, resp4 = ga4.call({})
puts resp4.first.include?("UA-88888-4") ? "json_has_tracking_WRONG" : "json_no_tracking_ok"

# Test 5: xhtml content type should also be injected
xhtml_app = lambda do |env|
  [200, {"Content-Type" => "application/xhtml+xml"}, ["<html><body>xhtml</body></html>"]]
end
ga5 = Rack::GoogleAnalytics.new(xhtml_app, web_property_id: "UA-55555-5")
_, _, resp5 = ga5.call({})
puts resp5.first.include?("UA-55555-5") ? "xhtml_has_tracking" : "xhtml_missing_tracking"
