# frozen_string_literal: true

require 'gull'

# --- Polygon ---
# GeoJSON coords are [lon, lat]; Polygon stores as [lat, lon]
coords = [
  [-87.6, 41.8],
  [-87.5, 41.9],
  [-87.4, 41.8],
  [-87.6, 41.8]
]
poly = Gull::Polygon.new(coords)
puts poly.to_s
puts poly.to_wkt

# --- Geocode ---
geo = Gull::Geocode.new
geo.ugc   = 'ILC031 ILC037'
geo.fips6 = '017031 017037'
puts geo.ugc
puts geo.fips6

# --- Alert (parsed from a synthetic GeoJSON feature) ---
feature = {
  'id' => 'https://api.weather.gov/alerts/urn:oid:2.49.0.1.840.0.111',
  'geometry' => {
    'type' => 'Polygon',
    'coordinates' => [
      [
        [-87.6, 41.8],
        [-87.5, 41.9],
        [-87.4, 41.8],
        [-87.6, 41.8]
      ]
    ]
  },
  'properties' => {
    'id'          => 'urn:oid:2.49.0.1.840.0.111',
    '@id'         => 'https://api.weather.gov/alerts/urn:oid:2.49.0.1.840.0.111',
    'headline'    => 'Tornado Warning',
    'description' => 'A large tornado is on the ground.',
    'event'       => 'Tornado Warning',
    'areaDesc'    => 'Cook County',
    'effective'   => '2024-05-15T18:00:00-05:00',
    'expires'     => '2024-05-15T18:30:00-05:00',
    'sent'        => '2024-05-15T17:55:00-05:00',
    'onset'       => '2024-05-15T18:00:00-05:00',
    'urgency'     => 'Immediate',
    'severity'    => 'Extreme',
    'certainty'   => 'Observed',
    'geocode'     => {
      'UGC'  => %w[ILC031],
      'SAME' => %w[017031]
    },
    'parameters'  => {
      'VTEC' => ['/O.NEW.KLOT.TO.W.0001.240515T2300Z-240515T2330Z/']
    }
  }
}

alert = Gull::Alert.new
alert.parse(feature)

puts alert.alert_type
puts alert.area
puts alert.urgency.inspect
puts alert.severity.inspect
puts alert.certainty.inspect
puts alert.vtec
puts alert.geocode.ugc
puts alert.polygon.to_s
