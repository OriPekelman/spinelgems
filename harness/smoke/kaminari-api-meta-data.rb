# frozen_string_literal: true

require 'kaminari_api_meta_data'

# Minimal stub that mimics a kaminari-paginated scope
class FakeCollection
  def initialize(current:, total_pages:, per_page:, total_count:)
    @current     = current
    @total_pages = total_pages
    @per_page    = per_page
    @total_count = total_count
  end

  def current_page = @current
  def limit_value  = @per_page
  def total_pages  = @total_pages
  def total_count  = @total_count
  def prev_page    = (@current > 1 ? @current - 1 : nil)
  def next_page    = (@current < @total_pages ? @current + 1 : nil)
end

class ApiController
  include KaminariApiMetaData
end

ctrl = ApiController.new

# Page 2 of 5, 20 per page, 100 total
col = FakeCollection.new(current: 2, total_pages: 5, per_page: 20, total_count: 100)
meta = ctrl.meta_data(col)
puts meta[:current_page]
puts meta[:prev_page]
puts meta[:next_page]
puts meta[:per_page]
puts meta[:total_pages]
puts meta[:total_count]

# Page 1 of 1 — no prev, no next; extra metadata merged
col2 = FakeCollection.new(current: 1, total_pages: 1, per_page: 10, total_count: 7)
meta2 = ctrl.meta_data(col2, { search: "ruby", filtered: true })
puts meta2[:current_page]
puts meta2[:prev_page].inspect
puts meta2[:next_page].inspect
puts meta2[:total_count]
puts meta2[:search]
puts meta2[:filtered]

# Last page — no next
col3 = FakeCollection.new(current: 5, total_pages: 5, per_page: 20, total_count: 100)
meta3 = ctrl.meta_data(col3)
puts meta3[:current_page]
puts meta3[:prev_page]
puts meta3[:next_page].inspect
