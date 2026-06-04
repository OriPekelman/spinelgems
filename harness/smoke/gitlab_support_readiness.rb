# frozen_string_literal: true
# Smoke: gitlab_support_readiness — exercises Readiness::Dates quarter logic
# and Readiness::Client pure helper methods (no network, no Redis, no Zendesk).

require 'date'
require 'json'

# The main require pulls in faraday/redis/google-api etc. — unavailable here.
# Load only the two pure modules we actually test.
module Readiness; end
require 'support_readiness/client'
require 'support_readiness/dates'

# --- Readiness::Dates ---

# Fixed reference dates to keep output deterministic
d_feb  = Time.new(2024, 2, 15)   # Feb → FY25Q1
d_jun  = Time.new(2024, 6, 1)    # Jun → FY25Q2
d_sep  = Time.new(2024, 9, 10)   # Sep → FY25Q3
d_nov  = Time.new(2024, 11, 20)  # Nov → FY25Q4
d_jan  = Time.new(2025, 1, 5)    # Jan → FY25Q4

puts Readiness::Dates.determine_quarter(d_feb)
puts Readiness::Dates.determine_quarter(d_jun)
puts Readiness::Dates.determine_quarter(d_sep)
puts Readiness::Dates.determine_quarter(d_nov)
puts Readiness::Dates.determine_quarter(d_jan)

# next_quarter transitions
puts Readiness::Dates.next_quarter(d_feb)   # Q1 → Q2
puts Readiness::Dates.next_quarter(d_nov)   # Q4 → Q1 of next FY year

# previous_quarter transitions
puts Readiness::Dates.previous_quarter(d_jun)  # Q2 → Q1
puts Readiness::Dates.previous_quarter(d_feb)  # Q1 → Q4 of prev FY year

# --- Readiness::Client ---

class SampleRecord
  def initialize(name, count, extra = nil)
    @name  = name
    @count = count
    @extra = extra
  end
end

rec = SampleRecord.new('widget', 7, nil)

# to_hash: all instance vars as string keys
h = Readiness::Client.to_hash(rec)
puts h['name']
puts h['count']
puts h.key?('extra')

# to_clean_json: nil values stripped
j = Readiness::Client.to_clean_json(rec)
parsed = JSON.parse(j)
puts parsed['name']
puts parsed['count']
puts parsed.key?('extra')

# to_clean_json_with_key: wrapped under a key
jk = Readiness::Client.to_clean_json_with_key(rec, 'record')
parsed2 = JSON.parse(jk)
puts parsed2['record']['name']
puts parsed2['record']['count']

# to_param_string
puts Readiness::Client.to_param_string(['page=1', 'per_page=25'])
puts Readiness::Client.to_param_string([]).empty?
