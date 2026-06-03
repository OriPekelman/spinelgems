# Smoke for cocoapods-search
# This gem is a CocoaPods plugin; Pod::Command (from cocoapods) is not available.
# We stub the minimum Pod/CLAide hierarchy so command/search.rb can load, then
# exercise the real query-building and URL-encoding logic from Pod::Command::Search.

require 'cgi'

# --- Minimal stubs so cocoapods-search/command/search.rb loads ---
module Pod
  class Command
    def self.summary=(s);      @summary = s;      end
    def self.description=(s);  @description = s;  end
    def self.arguments=(a);    @arguments = a;     end
    def self.options;          [];                 end
    def initialize(argv);      end
  end

  class Platform
    def self.all; []; end
  end
end

module CLAide
  class Argument
    def initialize(name, required); end
  end
end

require 'cocoapods-search'                # loads CocoapodsSearch::VERSION
require 'cocoapods-search/command/search' # loads Pod::Command::Search

# 1. VERSION constant
puts "version: #{CocoapodsSearch::VERSION}"

# 2. Class summary metadata (set via self.summary= in search.rb)
puts "summary: #{Pod::Command::Search.instance_variable_get(:@summary)}"

# 3. query_regex computation (plain terms are Regexp.escape'd, joined by space)
#    Mirrors the logic inside Pod::Command::Search#local_search
def build_query_regex(terms, use_regex: false)
  terms.reduce([]) { |result, q|
    result << (use_regex ? q : Regexp.escape(q))
  }.join(' ').strip
end

puts "regex(plain):  #{build_query_regex(['AFNetworking', 'iOS'])}"
puts "regex(plain2): #{build_query_regex(['Alamofire'])}"
puts "regex(regex):  #{build_query_regex(['^AF.*'], use_regex: true)}"
puts "regex(escape): #{build_query_regex(['React.js'])}"  # dot gets escaped

# 4. URL encoding for web_search — mirrors Pod::Command::Search#web_search
def build_web_url(query_terms, platform_filters = [])
  queries = platform_filters.map { |p| "on:#{p}" }
  queries += query_terms
  query_parameter = queries.compact.flatten.join(' ')
  "https://cocoapods.org/?q=#{CGI.escape(query_parameter).gsub('+', '%20')}"
end

puts "url(plain):    #{build_web_url(['Alamofire'])}"
puts "url(platform): #{build_web_url(['SDWebImage'], [:ios])}"
puts "url(multi):    #{build_web_url(['React', 'Native'])}"
