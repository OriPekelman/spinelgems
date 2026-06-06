# Require only the self-contained parts (version, rendering, request URL constants)
# Avoid command_builder.rb (needs 'mem', 'slop') and commands.rb (needs Mem via include)
require 'gem_search/version'
require 'gem_search/rendering'

# Define RUBYGEMS_URL before loading request.rb (normally set in gem_search.rb)
module GemSearch
  RUBYGEMS_URL = "https://rubygems.org"
end
require 'gem_search/request'

# Manually define ENABLE_SORT_OPTS (part of Commands::Run, which needs external Mem)
module GemSearch
  module Commands
    class Run
      ENABLE_SORT_OPTS = {
        "a" => "downloads",
        "n" => "name",
        "v" => "version_downloads"
      }
    end
  end
end

# 1. VERSION constant
puts GemSearch::VERSION

# 2. Request URL templates (pure string formatting)
puts GemSearch::Request::SEARCH_API % ["rails", 1]
puts GemSearch::Request::GEM_API    % ["rack"]

# 3. Rendering module: render fake gem data (pure column-formatting logic, no network)
class FakeRenderer
  include GemSearch::Rendering
end

renderer = FakeRenderer.new

gems = [
  { "name" => "rails", "version" => "7.2.0",
    "version_downloads" => 1_234_567, "downloads" => 98_765_432,
    "homepage_uri" => "https://rubyonrails.org" },
  { "name" => "rack", "version" => "3.1.0",
    "version_downloads" => 876_543, "downloads" => 55_000_000,
    "homepage_uri" => "https://rack.github.io" },
]

# Render with homepage column
renderer.render(gems, true)
puts "---"

# Render without homepage column
renderer.render(gems, false)

# 4. Sort-by logic on fake gem data
by_dl = gems.sort { |x, y| y["downloads"] <=> x["downloads"] }
puts "by_downloads: " + by_dl.map { |g| g["name"] }.join(", ")

by_name = gems.sort { |x, y| x["name"] <=> y["name"] }
puts "by_name: " + by_name.map { |g| g["name"] }.join(", ")

# 5. Sort opts map
puts "sort_opts: " + GemSearch::Commands::Run::ENABLE_SORT_OPTS.sort.map { |k, v| "#{k}=#{v}" }.join(", ")
