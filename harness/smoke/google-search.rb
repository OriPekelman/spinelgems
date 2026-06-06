require 'google-search'

# 1. Static helpers on Google::Search
puts Google::Search.size_for(:small)   # => 4
puts Google::Search.size_for(:large)   # => 8

# 2. URL encoding (pure string logic, no network)
puts Google::Search.url_encode("hello world")           # => hello+world
puts Google::Search.url_encode("foo&bar=baz")           # => foo%26bar%3Dbaz
puts Google::Search.url_encode("ruby gems")             # => ruby+gems

# 3. Construct a Search::Web object and inspect URI (no network)
s = Google::Search::Web.new(query: 'ruby gems', language: :en, size: :small)
puts s.query        # => ruby gems
puts s.language     # => en
puts s.size         # => small
puts s.offset       # => 0
puts s.type         # => web
uri = s.get_uri
puts uri.start_with?('http://www.google.com/uds/GwebSearch?') # => true
puts uri.include?('q=ruby+gems')   # => true
puts uri.include?('rsz=small')     # => true
puts uri.include?('hl=en')         # => true

# 4. Item.class_for dispatch
puts Google::Search::Item.class_for('GwebSearch')    # => Google::Search::Item::Web
puts Google::Search::Item.class_for('GimageSearch')  # => Google::Search::Item::Image
puts Google::Search::Item.class_for('GbookSearch')   # => Google::Search::Item::Book
puts Google::Search::Item.class_for('GnewsSearch')   # => Google::Search::Item::News

# 5. Response.new with a fake hash (no network, exercises parsing/item-building)
fake_hash = {
  'responseStatus'  => 200,
  'responseDetails' => nil,
  'responseSize'    => 'small',
  'responseData'    => {
    'cursor' => {
      'estimatedResultCount' => '42000',
      'currentPageIndex'     => 0
    },
    'results' => [
      {
        'GsearchResultClass'  => 'GwebSearch',
        'index'               => 0,
        'titleNoFormatting'   => 'Ruby Gems',
        'unescapedUrl'        => 'https://rubygems.org',
        'contentNoFormatting' => 'Find, install and publish RubyGems.',
        'visibleUrl'          => 'rubygems.org'
      },
      {
        'GsearchResultClass'  => 'GwebSearch',
        'index'               => 1,
        'titleNoFormatting'   => 'Ruby Lang',
        'unescapedUrl'        => 'https://ruby-lang.org',
        'contentNoFormatting' => 'The Ruby programming language.',
        'visibleUrl'          => 'ruby-lang.org'
      }
    ]
  }
}

resp = Google::Search::Response.new(fake_hash)
puts resp.valid?              # => true
puts resp.status              # => 200
puts resp.estimated_count     # => 42000
puts resp.items.length        # => 2
puts resp.items[0].title      # => Ruby Gems
puts resp.items[0].uri        # => https://rubygems.org
puts resp.items[0].visible_uri # => rubygems.org
puts resp.items[1].title      # => Ruby Lang

# 6. Response with error status
err_hash = { 'responseStatus' => 403, 'responseDetails' => 'Forbidden', 'responseData' => nil }
err = Google::Search::Response.new(err_hash)
puts err.valid?   # => false
puts err.status   # => 403
puts err.details  # => Forbidden
