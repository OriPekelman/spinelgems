module Bundler
  module Spinel
    # STUB — designed, not built. See ARCHITECTURE.md §"Platform variant".
    #
    # Opt-in mechanism to mark a gem "verified under Spinel" using RubyGems'
    # existing platform machinery — the same lever JRuby uses with the `java`
    # platform. A `verified` gem can be republished (to the curated source) with
    # a `spinel` platform; Bundler's normal platform resolution then *prefers*
    # the spinel variant and a missing variant is a clean resolution miss.
    #
    # `Gem::Platform.new("spinel")` parses to os="unknown" today, so the concrete
    # token is TBD (likely "<cpu>-spinel-<engine_rev>" so the badge is rev-scoped
    # — a variant verified under git:0adca86 should not silently satisfy a newer
    # engine). This is the bridge from "our private ledger says verified" to
    # "stock Bundler resolution selects it," and the reason verification is
    # opt-in: earning a platform badge means someone ran the gem's tests through
    # a Spinel-compiled harness.
    class Platform
      def initialize(*)
        raise Error, "Platform is a design stub — see ARCHITECTURE.md"
      end
    end
  end
end
