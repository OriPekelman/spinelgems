require 'lead_create'

# LeadCreate wraps Salesforce (databasedotcom) — no network available.
# We smoke the real code paths that don't need a live connection:
#   1. Class is defined with expected singleton methods
#   2. Calling .create without config raises the documented error
#   3. Calling .list_leads without config raises the documented error

puts LeadCreate.class                        # Class
puts LeadCreate.respond_to?(:create)         # true
puts LeadCreate.respond_to?(:list_leads)     # true

# Struct used as stand-in for a contact object
Contact = Struct.new(:name, :last_name, :email, :company, :job_title, :phone, :website)

begin
  LeadCreate.create(Contact.new('Alice', 'Smith', 'alice@example.com', 'Acme', 'Engineer', '555-0100', 'https://example.com'))
rescue RuntimeError => e
  puts e.message    # Please create file '/config/databasedotcom.yml'
rescue => e
  puts e.class.to_s + ': ' + e.message
end

begin
  LeadCreate.list_leads
rescue RuntimeError => e
  puts e.message    # Please create file '/config/databasedotcom.yml'
rescue => e
  puts e.class.to_s + ': ' + e.message
end
