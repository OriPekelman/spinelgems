# gnumarcelo-campaigning smoke
# This gem is a CampaignMonitor SOAP client built entirely on top of soap4r.
# It exercises: Subscriber object construction, Campaign attributes,
# custom_fields_array helper logic, and the Result value object.
# All of these require soap4r (xsd/qname, soap/rpc/driver) which is a
# mandatory runtime dependency — the gem cannot be required without it.
require 'gnumarcelo-campaigning'

# Subscriber construction and attribute access
sub = Campaigning::Subscriber.new('user@example.com', 'Test User', nil, 'Active', nil, :apiKey => 'test-key')
puts sub.emailAddress
puts sub.name
puts sub.state

# Campaign object construction
campaign = Campaigning::Campaign.new('camp-001', 'Test Campaign', '2024-01-01', 500, :apiKey => 'test-key')
puts campaign.campaignID
puts campaign.subject
puts campaign.totalRecipients

# List object construction
list = Campaigning::List.new('list-001', 'My Newsletter', :apiKey => 'test-key')
puts list.listID
puts list.name

# Result value object
result = Campaigning::Result.new(0, 'Success')
puts result.code
puts result.message
