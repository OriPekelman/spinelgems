# beef-articles smoke — Beef::Articles::UrlHelper mixin
# This gem is a Rails plugin; lib/articles.rb defines a URL helper mixin with
# article_path and article_url. We include it into a stub and call article_path.
require 'articles'

class ArticleUrlStub
  include Beef::Articles::UrlHelper

  # Stub the Rails permalink helper that UrlHelper delegates to
  def article_permalink_path(year, month, day, permalink, options = {})
    "/articles/#{year}/#{month}/#{day}/#{permalink}"
  end
end

ArticleStub = Struct.new(:published_at, :permalink)
helper = ArticleUrlStub.new

article = ArticleStub.new(Time.mktime(2024, 3, 15), "hello-world")
puts helper.article_path(article)

article2 = ArticleStub.new(Time.mktime(2010, 11, 2), "ruby-on-rails-intro")
puts helper.article_path(article2)

article3 = ArticleStub.new(Time.mktime(2000, 1, 1), "new-year")
puts helper.article_path(article3)
