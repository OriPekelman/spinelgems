# smoke: knife-okta
# Exercises KnifeOkta::VERSION and the pure-Ruby logic patterns
# from DataBagFromOktaGroup (regex matching, array set ops, attribute validation)
# without requiring Chef or Oktakit (both unavailable).

require 'knife-okta'

# 1. VERSION
puts KnifeOkta::VERSION

# 2. Replicate the okta_attribute validation logic from validate_okta_config
def valid_okta_attribute?(attr)
  %w{displayName email login}.include?(attr)
end

puts valid_okta_attribute?("email")       # true
puts valid_okta_attribute?("login")       # true
puts valid_okta_attribute?("displayName") # true
puts valid_okta_attribute?("password")    # false

# 3. Replicate group_hash selection logic (regex case-insensitive match on group name)
groups = [
  { type: "OKTA_GROUP", profile: { name: "Admins" }, id: "g1" },
  { type: "OKTA_GROUP", profile: { name: "developers" }, id: "g2" },
  { type: "APP_GROUP",  profile: { name: "Readers" }, id: "g3" },
]

def find_group(groups, group_name)
  groups.select { |g| g[:type] == "OKTA_GROUP" && g[:profile][:name] =~ /^#{group_name}$/i }.shift
end

puts find_group(groups, "admins")[:id]      # g1
puts find_group(groups, "DEVELOPERS")[:id]  # g2
puts find_group(groups, "Readers").nil?     # true (APP_GROUP excluded)

# 4. Replicate attribute_key_values: compact + sort + uniq across members
members = [
  { profile: { email: "bob@example.com" }, status: "ACTIVE" },
  { profile: { email: "alice@example.com" }, status: "ACTIVE" },
  { profile: { email: "bob@example.com" }, status: "ACTIVE" },
  { profile: { email: nil }, status: "ACTIVE" },
  { profile: { email: "carol@example.com" }, status: "SUSPENDED" },
]

active_members = members.select { |u| u[:status] == "ACTIVE" }
emails = active_members.map { |u| u[:profile][:email] }.compact.sort.uniq
puts emails.join(",")  # alice@example.com,bob@example.com

# 5. Replicate data_bag_item_additions / data_bag_item_removals set difference
existing = ["alice@example.com", "dave@example.com"]
current  = ["alice@example.com", "bob@example.com"]

additions = current - existing
removals  = existing - current
puts additions.join(",")  # bob@example.com
puts removals.join(",")   # dave@example.com

# 6. max_change check logic
def changes_within_range?(max_change, additions, removals)
  return true if max_change == 0
  changes = additions.size + removals.size
  max_change > changes
end

puts changes_within_range?(0, additions, removals)  # true (disabled)
puts changes_within_range?(5, additions, removals)  # true (1+1=2 < 5)
puts changes_within_range?(1, additions, removals)  # false (1+1=2 >= 1)
