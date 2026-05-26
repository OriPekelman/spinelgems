module Bundler
  module Spinel
    # STUB — designed, not built. See ARCHITECTURE.md §"Curated source".
    #
    # A read-through RubyGems proxy (Compact Index / `/api/v1/dependencies`)
    # that serves only gems whose ledger verdict for the current engine rev is
    # acceptable. Point a Gemfile at it:
    #
    #     source "http://localhost:9292"   # the spinel proxy
    #
    # and `bundle lock` resolves *only against vetted gems* — an incompatible
    # dependency becomes a "could not find compatible versions" resolution
    # failure, with no plugin required. The whitelist is not a separate file:
    # it is the set of acceptable verdicts in the ledger (`clean`/`verified`,
    # or `risky` when permitted), filtered to the proxy's pinned engine rev.
    #
    # Two modes:
    #   * permissive — proxy everything, but probe-on-first-serve and refuse to
    #     serve a `rejected` gem (lazy whitelist growth).
    #   * strict     — serve only `verified` gems (a real curated index).
    class Proxy
      def initialize(*)
        raise Error, "Proxy is a design stub — see ARCHITECTURE.md"
      end
    end
  end
end
