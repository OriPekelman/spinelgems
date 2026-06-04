# frozen_string_literal: true
# smoke: proxycrawl — API client library; exercises constructor validation,
# error constants, and class hierarchy without network calls.

require 'proxycrawl'

# 1. VERSION constant
puts ProxyCrawl::VERSION

# 2. API raises on missing token
begin
  ProxyCrawl::API.new
rescue RuntimeError => e
  puts e.message
end

begin
  ProxyCrawl::API.new({})
rescue RuntimeError => e
  puts e.message
end

# 3. API constructed successfully with a token
api = ProxyCrawl::API.new(token: 'test-token-abc', timeout: 30)
puts api.token
puts api.timeout

# 4. API raises on empty URL for get
begin
  api.get('')
rescue RuntimeError => e
  puts e.message
end

# 5. StorageAPI raises on missing token
begin
  ProxyCrawl::StorageAPI.new
rescue RuntimeError => e
  puts e.message
end

begin
  ProxyCrawl::StorageAPI.new(token: '')
rescue RuntimeError => e
  puts e.message
end

# 6. StorageAPI constructed successfully
storage = ProxyCrawl::StorageAPI.new(token: 'stor-token-xyz')
puts storage.token
puts storage.timeout

# 7. StorageAPI raises on empty URL/RID for get
begin
  storage.get('')
rescue RuntimeError => e
  puts e.message
end

# 8. LeadsAPI raises on missing token
begin
  ProxyCrawl::LeadsAPI.new
rescue RuntimeError => e
  puts e.message
end

begin
  ProxyCrawl::LeadsAPI.new(token: '')
rescue RuntimeError => e
  puts e.message
end

# 9. LeadsAPI constructed and post restriction
leads = ProxyCrawl::LeadsAPI.new(token: 'leads-token-def')
puts leads.token
begin
  leads.post
rescue RuntimeError => e
  puts e.message
end

# 10. ScraperAPI inherits from API (class hierarchy)
puts ProxyCrawl::ScraperAPI.superclass == ProxyCrawl::API

# 11. ScraperAPI post restriction
scraper = ProxyCrawl::ScraperAPI.new(token: 'scraper-token-ghi')
begin
  scraper.post
rescue RuntimeError => e
  puts e.message
end

# 12. ScreenshotsAPI inherits from API
puts ProxyCrawl::ScreenshotsAPI.superclass == ProxyCrawl::API

# 13. ScreenshotsAPI filename validation constant
puts ProxyCrawl::ScreenshotsAPI::INVALID_SAVE_TO_PATH_FILENAME
puts ProxyCrawl::ScreenshotsAPI::SAVE_TO_PATH_FILENAME_PATTERN === 'photo.jpg'
puts ProxyCrawl::ScreenshotsAPI::SAVE_TO_PATH_FILENAME_PATTERN === 'photo.png'

# 14. ScreenshotsAPI post restriction
screenshots = ProxyCrawl::ScreenshotsAPI.new(token: 'ss-token-jkl')
begin
  screenshots.post
rescue RuntimeError => e
  puts e.message
end

# 15. API error constants
puts ProxyCrawl::API::INVALID_TOKEN
puts ProxyCrawl::API::INVALID_URL
puts ProxyCrawl::StorageAPI::INVALID_RID
puts ProxyCrawl::StorageAPI::INVALID_RID_ARRAY
puts ProxyCrawl::StorageAPI::INVALID_URL_OR_RID
