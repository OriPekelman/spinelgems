require "webrick"

module Bundler
  module Spinel
    # One process serving both halves of spinelgems.org — the apex double-duty
    # layout as a single running app:
    #
    #   - the static human site (index.html, catalog.html, assets) via DocumentRoot
    #   - when a store of vetted .gem files is given, the machine Compact Index
    #     (/versions, /names, /info/<gem>, /gems/<file>.gem) mounted over the top
    #
    # This is what the deploy host (Upsun) runs on $PORT. The Compact Index paths
    # don't collide with the human paths, so `source "https://spinelgems.org"`
    # resolves against the curated source while a browser gets the site. The
    # dogfood target is to replace this WEBrick host with a Spinel-compiled Tep
    # app serving the same endpoints (see ARCHITECTURE.md §Dogfooding).
    class Server
      def initialize(public_dir:, store: nil, ledger: Ledger.new,
                     engine: Engine.new, min_verdict: :verified)
        @public_dir = public_dir
        @store = store
        @ledger = ledger
        @engine = engine
        @min_verdict = min_verdict
      end

      def run(port:, host: "0.0.0.0", quiet: true)
        server = WEBrick::HTTPServer.new(
          BindAddress: host, Port: port,
          DocumentRoot: @public_dir,
          Logger: WEBrick::Log.new(quiet ? File::NULL : $stderr),
          AccessLog: []
        )
        mount_index(server)
        %w[INT TERM].each { |sig| trap(sig) { server.shutdown } }
        warn "[spinelgems] serving #{@public_dir} on #{host}:#{port}" \
             "#{@store ? " + Compact Index from #{@store}" : ' (no --store: site only)'}"
        server.start
      end

      private

      def mount_index(server)
        return unless @store

        require_relative "proxy"
        Proxy.new(store: @store, ledger: @ledger, engine: @engine,
                  min_verdict: @min_verdict).mount_on(server)
      end
    end
  end
end
