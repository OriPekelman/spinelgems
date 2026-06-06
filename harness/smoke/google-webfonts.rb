require 'google-webfonts-rails'

# Exercise ConfigRenderer — the core public API of this gem.
# No Rails, no network, no filesystem.

r = GoogleWebfonts::ConfigRenderer.new

# 1. Render with no config — should return empty string
empty = r.render
puts empty.empty? ? "empty_ok" : "empty_FAIL"

# 2. Set google families and render
r2 = GoogleWebfonts::ConfigRenderer.new
r2.google = ['Open Sans', 'Roboto:400,700']
out2 = r2.render
puts out2.include?("WebFontConfig") ? "webfontconfig_ok" : "webfontconfig_FAIL"
puts out2.include?("Open Sans") ? "google_family_ok" : "google_family_FAIL"

# 3. Set typekit id
r3 = GoogleWebfonts::ConfigRenderer.new
r3.typekit = 'abc123'
out3 = r3.render
puts out3.include?("typekit") ? "typekit_ok" : "typekit_FAIL"
puts out3.include?("abc123") ? "typekit_id_ok" : "typekit_id_FAIL"

# 4. Set custom fonts (hash of family => url)
r4 = GoogleWebfonts::ConfigRenderer.new
r4.custom = { 'MyFont' => 'https://example.com/myfont.css' }
out4 = r4.render
puts out4.include?("MyFont") ? "custom_family_ok" : "custom_family_FAIL"
puts out4.include?("example.com") ? "custom_url_ok" : "custom_url_FAIL"

# 5. Set monotype project id
r5 = GoogleWebfonts::ConfigRenderer.new
r5.monotype = 'proj-99'
out5 = r5.render
puts out5.include?("monotype") ? "monotype_ok" : "monotype_FAIL"

# 6. Set fontdeck id
r6 = GoogleWebfonts::ConfigRenderer.new
r6.fontdeck = 'fd42'
out6 = r6.render
puts out6.include?("fontdeck") ? "fontdeck_ok" : "fontdeck_FAIL"

# 7. Combined render: google + typekit
r7 = GoogleWebfonts::ConfigRenderer.new
r7.google = ['Lato']
r7.typekit = 'xyz789'
out7 = r7.render
puts out7.include?("Lato") ? "combined_google_ok" : "combined_google_FAIL"
puts out7.include?("xyz789") ? "combined_typekit_ok" : "combined_typekit_FAIL"

# 8. ascender setter with hash
r8 = GoogleWebfonts::ConfigRenderer.new
r8.ascender = { 'my-key-001' => ['AscFont1', 'AscFont2'] }
out8 = r8.render
puts out8.include?("ascender") ? "ascender_ok" : "ascender_FAIL"
puts out8.include?("my-key-001") ? "ascender_key_ok" : "ascender_key_FAIL"
