# frozen_string_literal: true
require 'json'
require 'instagram_basic_display'

# ── Configuration (exercises env-var loading) ────────────────────────────────
ENV['INSTAGRAM_CLIENT_ID']     = 'test_client_42'
ENV['INSTAGRAM_CLIENT_SECRET'] = 'test_secret_99'
ENV['INSTAGRAM_REDIRECT_URI']  = 'https://example.com/callback'

cfg = InstagramBasicDisplay::Configuration.new(auth_token: 'tok_demo', version: 1)
puts cfg.client_id        # => test_client_42
puts cfg.client_secret    # => test_secret_99
puts cfg.redirect_uri     # => https://example.com/callback
puts cfg.auth_token       # => tok_demo
puts cfg.version          # => 1

# ── Response — mock a success HTTP response ──────────────────────────────────
# Build a minimal mock that satisfies Response's duck-typing on Net::HTTPResponse.
MockHTTP = Struct.new(:body, :code, :message)

success_json = JSON.generate({
  'id'       => '123456789',
  'username' => 'demo_user',
  'paging'   => {
    'next'     => 'https://graph.instagram.com/next_page',
    'previous' => 'https://graph.instagram.com/prev_page'
  }
})

resp = InstagramBasicDisplay::Response.new(MockHTTP.new(success_json, '200', 'OK'))
puts resp.status            # => 200
puts resp.success?          # => true
puts resp.next_page?        # => true
puts resp.previous_page?    # => true
puts resp.next_page_link    # => https://graph.instagram.com/next_page
puts resp.previous_page_link # => https://graph.instagram.com/prev_page

payload = resp.payload
puts payload.id             # => 123456789
puts payload.username       # => demo_user

# ── Response — no paging ─────────────────────────────────────────────────────
no_paging_json = JSON.generate({ 'media_type' => 'IMAGE', 'timestamp' => '2024-01-15T10:30:00+0000' })
resp2 = InstagramBasicDisplay::Response.new(MockHTTP.new(no_paging_json, '200', 'OK'))
puts resp2.next_page?       # => false
puts resp2.previous_page?   # => false
puts resp2.paging.nil?      # => true
p2 = resp2.payload
puts p2.media_type          # => IMAGE
puts p2.timestamp           # => 2024-01-15T10:30:00+0000

# ── Response — error body ────────────────────────────────────────────────────
error_json = JSON.generate({
  'error' => {
    'message'   => 'Invalid OAuth access token.',
    'type'      => 'OAuthException',
    'code'      => 190,
    'fbtrace_id' => 'abc123'
  }
})
resp3 = InstagramBasicDisplay::Response.new(MockHTTP.new(error_json, '400', 'Bad Request'))
puts resp3.success?         # => false
err = resp3.error
puts err.message            # => Invalid OAuth access token.
puts err.type               # => OAuthException
puts err.code               # => 190

# ── NoAuthToken error class ──────────────────────────────────────────────────
begin
  raise InstagramBasicDisplay::NoAuthToken, 'no token provided'
rescue InstagramBasicDisplay::NoAuthToken => e
  puts e.message            # => no token provided
  puts e.class              # => InstagramBasicDisplay::NoAuthToken
end

# ── VERSION ───────────────────────────────────────────────────────────────────
puts InstagramBasicDisplay::VERSION  # => 0.2.3
