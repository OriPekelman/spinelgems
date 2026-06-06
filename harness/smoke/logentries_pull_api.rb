require 'logentries_pull_api'

# VERSION constant
puts LogentriesPullApi::VERSION

# Client initialization and attr_readers
account_key = 'acct-' + ('a'..'z').to_a.first(8).join
log_set_key = 'lskey-12345'
log_key     = 'lkey-67890'

client = LogentriesPullApi::Client.new(account_key, log_set_key, log_key)
puts client.account_key
puts client.log_set_key
puts client.log_key

# Error class hierarchy
err = LogentriesPullApi::Error.new('something went wrong')
puts err.message
puts err.is_a?(StandardError)
puts err.class.name

# LOGENTRIES_API_URL constant
puts LogentriesPullApi::Client::LOGENTRIES_API_URL

# Client is a class within the module
puts LogentriesPullApi::Client.superclass.name

# Verify that get is defined as a public instance method
puts client.respond_to?(:get)
puts client.respond_to?(:account_key)
puts client.respond_to?(:log_set_key)
puts client.respond_to?(:log_key)

# assemble_uri is private
puts client.respond_to?(:assemble_uri, true)
puts client.respond_to?(:assemble_uri, false)
