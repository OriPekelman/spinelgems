require "webrick"
require "digest"
require "json"
require "rubygems/package"
require "time"

module Bundler
  module Spinel
    # A curated RubyGems *source* (Compact Index protocol) that serves only
    # vetted gems. Point a Gemfile at it:
    #
    #     source "http://localhost:9292"
    #     gem "cleangem"
    #
    # and `bundle lock` resolves *only against vetted gems*. A gem that isn't
    # served (no acceptable verdict for the pinned engine rev) becomes a plain
    # "could not find compatible versions" resolution failure — no plugin, no
    # engine-directive trick. The whitelist is not a file: it's the acceptable
    # subset of the ledger at this rev, plus a local store of .gem artifacts we
    # built/verified ourselves.
    #
    # Empirically the third-party rubygems ecosystem is ~all-rejected today, so
    # the load-bearing mode is `:store` — a directory of our own Spinel-vetted
    # .gem files. (Filtered read-through of upstream is a documented extension.)
    #
    # NOTE: this CRuby/WEBrick implementation is the MVP that proves Bundler
    # resolves against it. The dogfood target is to serve the same endpoints
    # from a Spinel-compiled Tep app — see ARCHITECTURE.md §"Dogfooding".
    class Proxy
      # store: dir of vetted *.gem files (the curated artifacts).
      def initialize(store:, ledger: Ledger.new, engine: Engine.new,
                     min_verdict: :verified)
        @store = store
        @ledger = ledger
        @engine = engine
        @min_verdict = min_verdict
      end

      # name => { version => spec } for every vetted gem in the store.
      def catalog
        @catalog ||= Dir[File.join(@store, "*.gem")].each_with_object({}) do |path, acc|
          spec = Gem::Package.new(path).spec
          next unless acceptable?(spec.name, spec.version.to_s)

          (acc[spec.name] ||= {})[spec.version.to_s] = { spec: spec, path: path }
        end
      end

      # Write the curated source as a *static* Compact Index tree:
      #   out/names  out/versions  out/info/<gem>  out/gems/<file>.gem
      # All digest/JSON happens here, offline, in CRuby. The result is plain
      # text + file bytes — so the dogfood server (Tep/Spinel, which has neither
      # digest nor JSON — probed 2026-05-26) only has to serve static files.
      def write_static(out)
        require "fileutils"
        FileUtils.mkdir_p(File.join(out, "info"))
        FileUtils.mkdir_p(File.join(out, "gems"))
        File.write(File.join(out, "names"), names_body)
        File.write(File.join(out, "versions"), versions_body)
        catalog.each_key { |name| File.write(File.join(out, "info", name), info_body(name)) }
        catalog.values.flat_map(&:values).each do |e|
          FileUtils.cp(e[:path], File.join(out, "gems", File.basename(e[:path])))
        end
        out
      end

      def serve(port: 9292, quiet: true)
        server = WEBrick::HTTPServer.new(
          Port: port,
          Logger: WEBrick::Log.new(quiet ? File::NULL : $stderr),
          AccessLog: []
        )
        mount(server)
        trap("INT") { server.shutdown }
        warn "[spinel-proxy] curated source on http://localhost:#{port} " \
             "(#{catalog.size} gems, min=#{@min_verdict}, rev=#{@engine.rev})"
        server.start
      end

      # Mount the Compact Index endpoints onto an existing WEBrick server, so a
      # combined server (Server) can serve the human site statically and the
      # curated source from the same process — the apex double-duty layout.
      def mount_on(server) = mount(server)

      private

      def acceptable?(name, version)
        v = @ledger.lookup(name, version, @engine.rev)
        return false unless v

        case @min_verdict
        when :verified then v.verified?
        when :loaded   then v.verified? || v.loaded?
        when :clean    then v.verified? || v.loaded? || v.clean?
        when :risky    then !v.rejected?
        else false
        end
      end

      def mount(server)
        server.mount_proc("/names") { |_, res| text(res, names_body) }
        server.mount_proc("/versions") { |_, res| text(res, versions_body) }
        server.mount_proc("/info") do |req, res|
          gem = req.path.sub(%r{\A/info/}, "")
          info = info_body(gem)
          info ? text(res, info) : (res.status = 404)
        end
        server.mount_proc("/gems") do |req, res|
          file = File.basename(req.path)
          entry = catalog.values.flat_map(&:values).find { |e| File.basename(e[:path]) == file }
          if entry
            res["Content-Type"] = "application/octet-stream"
            res.body = File.binread(entry[:path])
          else
            res.status = 404
          end
        end
      end

      # --- Compact Index bodies ---------------------------------------------

      def names_body
        "---\n" + catalog.keys.sort.join("\n") + "\n"
      end

      def versions_body
        out = +"created_at: #{Time.now.utc.iso8601}\n---\n"
        catalog.sort.each do |name, versions|
          vs = versions.keys.sort.join(",")
          out << "#{name} #{vs} #{::Digest::MD5.hexdigest(info_body(name))}\n"
        end
        out
      end

      def info_body(name)
        gem = catalog[name]
        return nil unless gem

        out = +"---\n"
        gem.sort.each do |version, entry|
          spec = entry[:spec]
          deps = spec.runtime_dependencies.map do |d|
            "#{d.name}:#{d.requirement.requirements.map { |op, v| "#{op} #{v}" }.join('&')}"
          end.join(",")
          sha = ::Digest::SHA256.hexdigest(File.binread(entry[:path]))
          ruby = spec.required_ruby_version.to_s
          out << "#{version} #{deps}|checksum:#{sha}"
          out << ",ruby:#{ruby}" unless ruby.empty? || ruby == ">= 0"
          out << "\n"
        end
        out
      end

      def text(res, body)
        res["Content-Type"] = "text/plain"
        res.body = body
      end
    end
  end
end
