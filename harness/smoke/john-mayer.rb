# frozen_string_literal: true

# john-mayer smoke — Foursquare API client (lib/foursquare.rb).
# Requires typhoeus (not available); stub it in $LOADED_FEATURES so the
# module loads.  All real API calls need network; instead exercise the
# pure data-model classes (User, Venue, Checkin) with mock JSON hashes
# and the module-level verbose flag + ERRORS constant table.

$LOADED_FEATURES << "typhoeus"
module Typhoeus; end

require "foursquare"

# 1. Module-level verbose flag (getter/setter)
puts Foursquare.verbose?.inspect     # nil (falsy)
Foursquare.verbose = true
puts Foursquare.verbose?             # true
Foursquare.verbose = false

# 2. ERRORS hash — built-in error descriptions
puts Foursquare::ERRORS["invalid_auth"]
puts Foursquare::ERRORS["rate_limit_exceeded"]
puts Foursquare::ERRORS["server_error"]

# 3. User data model: accessors over a mock JSON blob
user = Foursquare::User.new(nil, {
  "id"        => "u001",
  "firstName" => "Jane",
  "lastName"  => "Doe",
  "gender"    => "female",
  "homeCity"  => "New York, NY"
})
puts user.id
puts user.first_name
puts user.last_name
puts user.name          # "Jane Doe" — joins first + last with strip
puts user.gender
puts user.home_city

# 4. Venue data model: stats + verified? predicate
venue = Foursquare::Venue.new(nil, {
  "id"       => "v42",
  "name"     => "Spinel HQ",
  "verified" => true,
  "stats"    => { "checkinsCount" => 999, "usersCount" => 42 },
  "todos"    => { "count" => 3 }
})
puts venue.id
puts venue.name
puts venue.verified?
puts venue.checkins_count
puts venue.users_count
puts venue.todos_count

# 5. Checkin data model: type, shout?, mayor?, timezone
checkin = Foursquare::Checkin.new(nil, {
  "id"        => "ci99",
  "type"      => "checkin",
  "shout"     => "Hello world",
  "isMayor"   => false,
  "timeZone"  => "America/New_York"
})
puts checkin.id
puts checkin.type
puts checkin.shout?          # false — type is "checkin" not "shout"
puts checkin.shout
puts checkin.mayor?
puts checkin.timezone

# 6. Shout-type checkin
shout = Foursquare::Checkin.new(nil, { "type" => "shout", "shout" => "Just passing by" })
puts shout.shout?            # true
puts shout.shout
