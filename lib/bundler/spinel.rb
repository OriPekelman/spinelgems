module Bundler
  module Spinel
    class Error < StandardError; end
  end
end

require_relative "spinel/version"
require_relative "spinel/engine"
require_relative "spinel/ledger"
require_relative "spinel/gem_fetcher"
require_relative "spinel/probe"
require_relative "spinel/checker"
