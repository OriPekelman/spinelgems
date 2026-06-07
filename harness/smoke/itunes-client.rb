# smoke: itunes-client
# Tests pure Ruby logic in Track (init, attr access, find_conditions)
# and module constants — all without calling osascript (macOS-only).
require 'itunes-client'

# VERSION constant
puts Itunes::VERSION

# Track ATTRIBUTES and FINDER_ATTRIBUTES constants
puts Itunes::Track::ATTRIBUTES.length
puts Itunes::Track::FINDER_ATTRIBUTES.include?(:persistent_id)
puts Itunes::Track::FINDER_ATTRIBUTES.include?(:artist)

# Track initialization with a hash
t = Itunes::Track.new(
  name: 'Purple Rain',
  artist: 'Prince',
  album: 'Purple Rain',
  track_number: 1,
  track_count: 9,
  year: 1984
)
puts t.name
puts t.artist
puts t.album
puts t.track_number
puts t.year

# find_conditions builds the AppleScript filter string from a hash
cond = Itunes::Track.send(:find_conditions, { name: 'Purple Rain', artist: 'Prince' })
puts cond

# update_attribute_records (private) builds the AppleScript update lines
records = t.send(:update_attribute_records, { name: 'When Doves Cry', track_number: 2 })
puts records.include?('set name of specified_track to "When Doves Cry"')
puts records.include?('set track number of specified_track to "2"')

# assign_attributes_by populates from a string-keyed hash (as JSON.parse returns)
t2 = Itunes::Track.new
t2.assign_attributes_by({
  'persistent_id' => 'ABC123',
  'name'          => 'Kiss',
  'artist'        => 'Prince',
  'album'         => 'Parade',
  'year'          => '1986',
  'track_count'   => '9',
  'track_number'  => '4',
  'season_number' => nil,
  'episode_number'=> nil,
  'show'          => nil,
  'video_kind'    => nil
})
puts t2.persistent_id
puts t2.name
puts t2.year

# Player and Volume class constants exist
puts Itunes::Player.is_a?(Class)
puts Itunes::Volume.is_a?(Class)
puts Itunes::Player::FileNotFoundError.ancestors.include?(StandardError)
puts Itunes::Player::EmptyFileError.ancestors.include?(StandardError)
