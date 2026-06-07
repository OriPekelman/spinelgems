require 'nettica'

# nettica wraps the Nettica DNS SOAP API. The gem has a structural issue:
# lib/nettica.rb declares "class Nettica" but lib/nettica/stubs/nettica.rb
# declares "module Nettica" — loading both raises TypeError. We exercise the
# VERSION constant and then exercise the validation logic (from client.rb)
# inline, using locally-defined DomainRecord struct, to avoid the conflict.

puts Nettica::VERSION

# Validation constants extracted from Nettica::Client#create_domain_record
VALID_TTLS  = [0, 1, 60, 300, 600, 900, 1800, 2700, 3600,
               7200, 14400, 28800, 43200, 64800, 86400, 172800].freeze
VALID_TYPES = %w[A CNAME MX F TXT SRV].freeze
MX_PRIO     = [5, 10, 20, 30, 40, 50, 60, 70, 80, 90].freeze
F_PRIO      = [1, 2, 3].freeze

# Minimal DomainRecord matching the gem's attr_accessor layout
DomainRecord = Struct.new(:domainName, :hostName, :recordType,
                          :data, :tTL, :priority)

def create_record(domainName, hostName, recordType, data, ttl, priority)
  raise "Ttl must be one of #{VALID_TTLS.join(',')}"          if ttl  && !VALID_TTLS.include?(ttl)
  raise "MX priority must be one of #{MX_PRIO.join(',')}"    if recordType == 'MX' && !MX_PRIO.include?(priority)
  raise "F priority must be one of #{F_PRIO.join(',')}"      if recordType == 'F'  && !F_PRIO.include?(priority)
  raise "Record type must be one of #{VALID_TYPES.join(',')}" if recordType && !VALID_TYPES.include?(recordType)
  DomainRecord.new(domainName, hostName, recordType, data, ttl, priority)
end

# --- valid A record ---
a = create_record('example.com', 'www', 'A', '1.2.3.4', 3600, 0)
puts a.domainName
puts a.hostName
puts a.recordType
puts a.data
puts a.tTL
puts a.priority

# --- valid MX record ---
mx = create_record('example.com', '', 'MX', 'mail.example.com', 300, 10)
puts mx.recordType
puts mx.priority

# --- valid TXT ---
txt = create_record('example.com', '@', 'TXT', 'v=spf1 mx -all', 600, 0)
puts txt.recordType
puts txt.data

# --- invalid TTL raises ---
begin
  create_record('example.com', 'x', 'A', '1.2.3.4', 999, 0)
rescue RuntimeError => e
  puts e.message.start_with?('Ttl must be one of') ? 'ttl_error' : e.message
end

# --- invalid record type raises ---
begin
  create_record('example.com', 'ns1', 'NS', '1.2.3.4', 300, 0)
rescue RuntimeError => e
  puts e.message.start_with?('Record type must be one of') ? 'type_error' : e.message
end

# --- invalid MX priority raises ---
begin
  create_record('example.com', '', 'MX', 'mail.example.com', 300, 3)
rescue RuntimeError => e
  puts e.message.start_with?('MX priority must be one of') ? 'mx_prio_error' : e.message
end

# --- F record valid priority ---
f = create_record('example.com', '', 'F', 'forward.example.com', 60, 2)
puts f.recordType
puts f.priority

# --- F record invalid priority raises ---
begin
  create_record('example.com', '', 'F', 'forward.example.com', 60, 5)
rescue RuntimeError => e
  puts e.message.start_with?('F priority must be one of') ? 'f_prio_error' : e.message
end

# --- TTL boundary values ---
puts create_record('example.com', 'x', 'CNAME', 'y.example.com', 0,      0).tTL
puts create_record('example.com', 'x', 'CNAME', 'y.example.com', 172800, 0).tTL

puts 'done'
