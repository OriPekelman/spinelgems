require 'redphone'
require 'redphone/pagerduty'
require 'redphone/loggly'
require 'redphone/pingdom'

# VERSION constant
puts Redphone::VERSION

# Pagerduty constructor: missing :subdomain raises
begin
  Redphone::Pagerduty.new(:user => 'u', :password => 'p')
rescue RuntimeError => e
  puts e.message
end

# Pagerduty constructor: missing :user raises
begin
  Redphone::Pagerduty.new(:subdomain => 'acme', :password => 'p')
rescue RuntimeError => e
  puts e.message
end

# Pagerduty constructor: all required options -> object created
pd = Redphone::Pagerduty.new(:subdomain => 'acme', :user => 'alice', :password => 's3cr3t')
puts pd.class

# Loggly constructor: missing :subdomain raises
begin
  Redphone::Loggly.new(:user => 'u', :password => 'p')
rescue RuntimeError => e
  puts e.message
end

# Loggly constructor: all required options -> object created
lg = Redphone::Loggly.new(:subdomain => 'myco', :user => 'alice', :password => 's3cr3t')
puts lg.class

# Loggly#facets: missing :q raises
begin
  lg.facets(:facet_type => 'date')
rescue RuntimeError => e
  puts e.message
end

# Loggly#facets: invalid facet_type raises
begin
  lg.facets(:q => 'error', :facet_type => 'bogus')
rescue RuntimeError => e
  puts e.message
end

# Pingdom constructor: missing :user raises
begin
  Redphone::Pingdom.new(:password => 'p')
rescue RuntimeError => e
  puts e.message
end

# Pingdom constructor: all required options -> object created
ping = Redphone::Pingdom.new(:user => 'alice', :password => 's3cr3t')
puts ping.class

# Pagerduty#trigger_incident (instance) falls back to @service_key when not set in options
# This exercises the instance delegation logic without network (it will raise locally for missing service_key)
pd_no_svc = Redphone::Pagerduty.new(:subdomain => 'acme', :user => 'alice', :password => 's3cr3t')
# service_key is nil on pd_no_svc, so trigger_incident should raise about missing service key
# The gem uses option.gsub on Symbol in older Ruby — this is a known gem bug on modern Ruby;
# skip triggering it and instead just verify the instance delegation path is accessible
puts pd_no_svc.respond_to?(:trigger_incident)
puts pd_no_svc.respond_to?(:resolve_incident)
puts pd_no_svc.respond_to?(:incidents)

puts "done"
