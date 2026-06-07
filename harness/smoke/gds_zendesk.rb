# gds_zendesk smoke — exercises DummyClient and related classes.
# The gem's top-level entry only loads VERSION; the real logic is in
# sub-files that depend on null_logger + zendesk_api.  We add those gem
# lib dirs (or stubs) to $LOAD_PATH before requiring the sub-files.

require 'gds_zendesk'
puts GDSZendesk::VERSION

# Add null_logger from the local gem cache.
NL_LIB = File.expand_path(
  '~/.cache/spinel-compat/gems/null_logger-0.0.1/lib'
)
$LOAD_PATH.unshift(NL_LIB) if File.directory?(NL_LIB)

# Add a stub dir for zendesk_api/error (avoids loading Faraday+TLS).
ZD_STUB = '/tmp/gds_zd_stubs'
unless File.exist?("#{ZD_STUB}/zendesk_api/error.rb")
  require 'fileutils'
  FileUtils.mkdir_p("#{ZD_STUB}/zendesk_api")
  File.write("#{ZD_STUB}/zendesk_api/error.rb", <<~RB)
    module ZendeskAPI
      module Error
        class RecordInvalid < StandardError
          def initialize(body: nil)
            super(body.inspect)
          end
        end
      end
    end
  RB
end
$LOAD_PATH.unshift(ZD_STUB) unless $LOAD_PATH.include?(ZD_STUB)

# Now we can safely require the sub-file (CRuby: -I lib; Spinel: inlines).
require 'gds_zendesk/dummy_client'

# 1. DummyClient instantiation
dc = GDSZendesk::DummyClient.new({})
puts dc.class
puts dc.ticket.class
puts dc.users.class

# 2. DummyUsers#search always returns []
result = dc.users.search(query: 'nobody@example.com')
puts result.inspect

# 3. DummyUsers#suspended? always returns false
puts dc.users.suspended?('user@example.com').inspect

# 4. DummyTicket#create! normal path — no exception
dc.ticket.create!(description: 'Help with login', comment: { value: 'Details here' })
puts 'ticket:ok'
puts dc.ticket.options[:description]

# 5. DummyTicket#create! raises on break_zendesk keyword
begin
  dc.ticket.create!(description: 'break_zendesk trigger', comment: { value: 'boom' })
  puts 'ticket:no_error'
rescue ZendeskAPI::Error::RecordInvalid
  puts 'ticket:error_raised'
end
