# book_finder_api smoke
# The gem has exactly one public method: BookFinder.flipkart(isbn)
# That method requires Mechanize (external runtime dep) and makes live
# HTTP calls to flipkart.com — no offline logic exists to exercise.
# The only thing we can safely validate is the module constant.
require 'book_finder_api'

puts BookFinderApi::VERSION
