# frozen_string_literal: true

# Smoke test for weneedfeed — exercises Item.parse_time, PageSchema struct,
# and Item instantiation with a mock Nokogiri-like node.
# weneedfeed depends on addressable, marcel (and nokogiri at runtime), none of
# which are in the harness load path.  We pre-stub the three external requires
# so the gem loads cleanly; the logic we exercise is pure Ruby.

require 'tmpdir'
require 'fileutils'
require 'time'
require 'digest/sha1'

# ------------------------------------------------------------------
# Stub external gems that weneedfeed requires at the top level
# ------------------------------------------------------------------
_stub_dir = Dir.mktmpdir('weneedfeed-smoke-stubs')

FileUtils.mkdir_p File.join(_stub_dir, 'addressable')
File.write(File.join(_stub_dir, 'addressable.rb'), <<~RUBY)
  module Addressable
    class URI
      def self.join(*_args) new end
      def normalize; self end
      def to_s; 'https://example.com/resolved' end
    end
  end
RUBY
File.write(File.join(_stub_dir, 'addressable', 'uri.rb'), "# stub\n")
File.write(File.join(_stub_dir, 'marcel.rb'), <<~RUBY)
  module Marcel
    class Magic
      def self.by_path(_path) nil end
    end
  end
RUBY

$LOAD_PATH.unshift(_stub_dir)

require 'weneedfeed'

# ------------------------------------------------------------------
# 1. Item.parse_time — Japanese date format (年月日)
# ------------------------------------------------------------------
t1 = Weneedfeed::Item.parse_time('2024年03月15日')
puts t1.strftime('%Y-%m-%d')           # => 2024-03-15

# ------------------------------------------------------------------
# 2. Item.parse_time — ISO / generic format via Time.parse fallback
# ------------------------------------------------------------------
t2 = Weneedfeed::Item.parse_time('2024-01-15')
puts t2.strftime('%Y-%m-%d')           # => 2024-01-15

# ------------------------------------------------------------------
# 3. Item.parse_time — garbage input returns nil
# ------------------------------------------------------------------
t3 = Weneedfeed::Item.parse_time('not a date at all')
puts t3.nil?                           # => true

# ------------------------------------------------------------------
# 4. PageSchema — keyword-init Struct round-trip
# ------------------------------------------------------------------
ps = Weneedfeed::PageSchema.new(
  description: 'A test feed',
  id: 'example-feed',
  item_description_selector: '.desc',
  item_image_selector: nil,
  item_link_selector: 'a',
  item_time_selector: 'time',
  item_title_selector: 'h2',
  item_selector: '.post',
  title: 'Example Feed',
  url: 'https://example.com'
)
puts ps.id             # => example-feed
puts ps.title          # => Example Feed
puts ps.url            # => https://example.com
puts ps.item_selector  # => .post

# ------------------------------------------------------------------
# 5. Item — instantiate with mock node, exercise title/description/guid
# ------------------------------------------------------------------
class MockNode
  def at(sel)
    case sel
    when 'h2'    then MockElement.new('Article Title')
    when '.desc' then MockElement.new('Article body text')
    when 'a'     then MockElement.new(nil, href: '/articles/42')
    end
  end
end

class MockElement
  def initialize(text, href: nil)
    @text = text
    @href = href
  end
  def inner_text; @text; end
  def inner_html; @text; end
  def [](key); key == 'href' ? @href : nil; end
  def name; 'div'; end
  def content; @text; end
end

item = Weneedfeed::Item.new(
  description_selector: '.desc',
  image_selector: nil,
  link_selector: 'a',
  node: MockNode.new,
  time_selector: nil,
  title_selector: 'h2',
  url: 'https://example.com'
)
puts item.title                        # => Article Title
puts item.description                  # => Article body text
puts item.guid.start_with?('https://') # => true (resolved via Addressable stub)

# ------------------------------------------------------------------
# 6. Schema DEFAULT_TITLE constant
# ------------------------------------------------------------------
puts Weneedfeed::Schema::DEFAULT_TITLE # => Weneedfeed
