# smoke: pagerduty — pure-Ruby surface (version, exception class, ArgumentError paths)
puts Pagerduty::VERSION

puts PagerdutyException.ancestors.include?(StandardError)
puts PagerdutyException.instance_method(:pagerduty_instance).arity
puts PagerdutyException.instance_method(:api_response).arity

begin
  Pagerduty.build({})
rescue ArgumentError => e
  puts e.message
end

begin
  Pagerduty.build(integration_key: "key", incident_key: "bad")
rescue ArgumentError => e
  puts e.message
end

begin
  Pagerduty.build(integration_key: "key", api_version: 99)
rescue ArgumentError => e
  puts e.message
end
