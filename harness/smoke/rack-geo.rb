# Smoke: rack-geo-locale — Rack::GeoLocale middleware
# Tests Accept-Language header parsing (q-value priority, language+country split,
# missing header). GeoIP DB lookup is stubbed (requires no external file).
#
# BEGIN stub: geoip is a runtime dep that is unavailable in the verify harness.
# Marking it as already loaded before any require_relative fires (BEGIN blocks
# run before anything else in the concatenated harness file) lets CRuby skip
# the real `require 'geoip'` without error. parse_country is also patched out
# so the rest of the middleware's pure-Ruby logic is free to run.

BEGIN {
  module GeoIP; end          # minimal constant so the gem doesn't blow up
  $LOADED_FEATURES << "geoip"
}

require 'rack/geo_locale'

# Patch: skip GeoIP database fetch + geo-IP country lookup — both need an
# external binary database file that isn't present at test time.
Rack::GeoLocale.class_eval do
  def initialize(app)
    @geoip = nil
    @app = app
  end

  def parse_country(_env)
    nil  # country comes from Accept-Language only in this smoke
  end
end

results = []
app_stub = ->(env) { results << [env['locale.language'], env['locale.country']]; [200, {}, []] }
mw = Rack::GeoLocale.new(app_stub)

# 1: English US (highest q wins)
mw.call('HTTP_ACCEPT_LANGUAGE' => 'en-US,en;q=0.9,fr;q=0.8', 'REMOTE_ADDR' => '127.0.0.1')
puts results[-1].inspect

# 2: French from France
mw.call('HTTP_ACCEPT_LANGUAGE' => 'fr-FR,fr;q=0.9', 'REMOTE_ADDR' => '127.0.0.1')
puts results[-1].inspect

# 3: No Accept-Language header → both nil
mw.call('REMOTE_ADDR' => '127.0.0.1')
puts results[-1].inspect

# 4: German with explicit q=1.0
mw.call('HTTP_ACCEPT_LANGUAGE' => 'de-DE;q=1.0', 'REMOTE_ADDR' => '127.0.0.1')
puts results[-1].inspect

# 5: q-value priority — fr (0.9) beats en (0.5), no country tag on fr
mw.call('HTTP_ACCEPT_LANGUAGE' => 'fr;q=0.9,en;q=0.5', 'REMOTE_ADDR' => '127.0.0.1')
puts results[-1].inspect
