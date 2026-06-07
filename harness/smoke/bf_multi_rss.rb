require 'bf_multi_rss'
require 'bf_multi_rss/rss_result'
require 'bf_multi_rss/rss_error'

# Exercise RssResult
result = BfMultiRss::RssResult.new('http://example.com/feed.rss', ['item1', 'item2', 'item3'])
puts result.src
puts result.posts.length
puts result.posts.first

# Exercise RssResult with default empty posts
empty_result = BfMultiRss::RssResult.new('http://other.com/feed.rss')
puts empty_result.src
puts empty_result.posts.length

# Exercise RssError
error = BfMultiRss::RssError.new('http://bad.com/feed.rss', 'Http404 http://bad.com/feed.rss')
puts error.uri
puts error.e

# Test module namespace
puts BfMultiRss.name
