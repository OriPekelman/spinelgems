require_relative "../spinel"

module Bundler
  module Spinel
    # Thin command dispatcher shared by the `spinel-compat` executable and the
    # Bundler plugin command. Keeps all logic in the library classes.
    class CLI
      VERDICT_GLYPH = {
        "clean" => "✓", "loaded" => "○", "verified" => "★", "risky" => "~", "rejected" => "✗"
      }.freeze

      def initialize(out: $stdout, err: $stderr)
        @out = out
        @err = err
      end

      def run(argv)
        cmd = argv.shift
        case cmd
        when "engine"  then cmd_engine
        when "probe"   then cmd_probe(argv)
        when "verify"  then cmd_verify(argv)
        when "vendor"  then cmd_vendor(argv)
        when "check"   then cmd_check(argv)
        when "serve"   then cmd_serve(argv)
        when "build-index" then cmd_build_index(argv)
        when "build-site"  then cmd_build_site(argv)
        when "server"      then cmd_server(argv)
        when "ledger"  then cmd_ledger(argv)
        when "diff"    then cmd_diff(argv)
        when "detect-ext" then cmd_detect_ext(argv)
        when "reprobe" then cmd_reprobe(argv)
        when "survey"  then cmd_survey(argv)
        when "enrich"  then cmd_enrich(argv)
        when nil, "-h", "--help", "help" then usage; 0
        else
          @err.puts "unknown command: #{cmd}"; usage; 2
        end
      rescue Error => e
        @err.puts "[spinel-compat] #{e.message}"; 1
      end

      private

      def cmd_engine
        e = Engine.new
        @out.puts "spinel binary : #{e.bin} (#{e.available? ? 'found' : 'MISSING'})"
        @out.puts "engine rev    : #{e.rev}"
        @out.puts "ledger        : #{Ledger.new.path}"
        e.available? ? 0 : 1
      end

      def cmd_probe(argv)
        dir = (i = argv.index("--dir")) ? argv.delete_at(i + 1).tap { argv.delete_at(i) } : nil
        name = argv.shift or raise Error, "usage: spinel-compat probe NAME [VERSION] [--dir PATH]"
        engine = Engine.new
        if dir
          # Local source (a path:/git: sibling, or a checkout under test).
          version = argv.shift || "path"
          v = Probe.new(engine, Ledger.new).probe(name, version, File.expand_path(dir))
        else
          version = argv.shift || latest_version(name)
          v = Probe.new(engine, Ledger.new).probe(name, version, GemFetcher.new.fetch(name, version))
        end
        print_verdict(v)
        v.rejected? ? 1 : 0
      end

      def cmd_verify(argv)
        dir = (i = argv.index("--dir")) ? argv.delete_at(i + 1).tap { argv.delete_at(i) } : nil
        smoke = (j = argv.index("--smoke")) ? argv.delete_at(j + 1).tap { argv.delete_at(j) } : nil
        full = !!argv.delete("--full")
        name = argv.shift or raise Error, "usage: spinel-compat verify NAME [VERSION] [--dir PATH] [--smoke FILE] [--full]"
        engine = Engine.new
        if dir
          version = argv.shift || "path"
          gem_dir = File.expand_path(dir)
        else
          version = argv.shift || latest_version(name)
          gem_dir = GemFetcher.new.fetch(name, version)
        end
        v = Verifier.new(engine, Ledger.new).verify(name, version, gem_dir, smoke: smoke && File.expand_path(smoke), full: full)
        print_verdict(v)
        (v.verified? || v.loaded?) ? 0 : 1
      end

      def cmd_vendor(argv)
        into = (i = argv.index("--into")) ? argv.delete_at(i + 1).tap { argv.delete_at(i) } : "vendor/spinel"
        # --ext @PLACEHOLDER@=/abs/x.o : reuse a prebuilt .o instead of recompiling (repeatable).
        ext_overrides = {}
        while (e = argv.index("--ext"))
          pair = argv.delete_at(e + 1).to_s
          argv.delete_at(e)
          k, v = pair.split("=", 2)
          ext_overrides[k] = File.expand_path(v) if k && v
        end
        # --no-ext NAME : opt out of an optional C extension (repeatable; also SPINEL_EXT_DISABLE).
        ext_disable = []
        while (d = argv.index("--no-ext"))
          ext_disable << argv.delete_at(d + 1).to_s
          argv.delete_at(d)
        end
        lock = argv.shift || "Gemfile.lock"
        raise Error, "no #{lock}; run `bundle lock` first" unless File.exist?(lock)

        res = Vendorer.new.vendor(lock, into: into, ext_overrides: ext_overrides, ext_disable: ext_disable)
        ext = res[:extensions].to_i
        @out.puts "vendored #{res[:count]} gem(s)#{ext.positive? ? " (+#{ext} C ext)" : ''} -> #{res[:into]}"
        @out.puts "  require_relative \"#{res[:into]}/deps\" from your Spinel entrypoint"
        0
      end

      def cmd_check(argv)
        strict = argv.delete("--strict")
        lock = argv.shift || "Gemfile.lock"
        raise Error, "no #{lock}; run `bundle lock` first" unless File.exist?(lock)

        res = Checker.new.check(lock, strict: !!strict)
        res.probed.sort_by(&:gem).each { |v| print_verdict(v) }
        @out.puts "—" * 48
        if res.verdict
          @out.puts "OK: #{res.probed.size} gems compatible with #{Engine.new.rev}" \
                    "#{strict ? ' (strict)' : ''}"
          0
        else
          @err.puts "REJECTED under #{Engine.new.rev}:"
          res.rejected.each { |v| @err.puts "  ✗ #{v.gem} #{v.version} — #{v.reasons.join(', ')}" }
          res.risky.each { |v| @err.puts "  ~ #{v.gem} #{v.version} — risky: #{v.risks.join(', ')}" } if strict
          1
        end
      end

      def cmd_serve(argv)
        require_relative "proxy"
        store = (i = argv.index("--store")) ? argv[i + 1] : raise(Error, "serve needs --store DIR (vetted .gem files)")
        port = (j = argv.index("--port")) ? argv[j + 1].to_i : 9292
        min = (k = argv.index("--min")) ? argv[k + 1].to_sym : :verified
        Proxy.new(store: File.expand_path(store), min_verdict: min).serve(port: port)
        0
      end

      def cmd_build_index(argv)
        require_relative "proxy"
        store = (i = argv.index("--store")) ? argv[i + 1] : raise(Error, "build-index needs --store DIR")
        out = (j = argv.index("--out")) ? argv[j + 1] : raise(Error, "build-index needs --out DIR")
        min = (k = argv.index("--min")) ? argv[k + 1].to_sym : :verified
        dir = Proxy.new(store: File.expand_path(store), min_verdict: min).write_static(File.expand_path(out))
        @out.puts "wrote static curated index to #{dir} (serve it as a `source`)"
        0
      end

      # Fetch rubygems.org metadata (description, downloads, last-update, …) for a
      # gem list (or the ledger at this rev) into a meta.jsonl sidecar.
      def cmd_enrich(argv)
        require_relative "enricher"
        out = (j = argv.index("--out")) ? File.expand_path(argv[j + 1]) : raise(Error, "enrich needs --out FILE")
        jobs = (i = argv.index("--jobs")) ? argv.delete_at(i + 1).to_i.tap { argv.delete_at(i) } : 8
        list = (k = argv.index("--list")) ? argv[k + 1] : nil
        names = if list
                  File.readlines(File.expand_path(list)).map(&:strip).reject { |l| l.empty? || l.start_with?("#") }
                else
                  rev = Engine.new.rev
                  seen = {}
                  Ledger.new.each { |v| seen[v.gem] = true if v.rev == rev }
                  seen.keys
                end
        Enricher.new(out: out, jobs: jobs).run(names)
        @out.puts "wrote #{out} (#{names.size} gems)"
        0
      end

      # Per-gem verdict diff between two revs in the ledger — see what improved
      # or regressed between two surveys. Revs match by prefix (the leading
      # `git:<sha>` is enough); pass --names to list the gems per transition.
      #
      #   spinel-compat diff git:2183a92 git:a03bb49 [--names]
      def cmd_diff(argv)
        names_flag = !!argv.delete("--names")
        rev_a = argv.shift or raise Error, "usage: spinel-compat diff REV_A REV_B [--names]"
        rev_b = argv.shift or raise Error, "usage: spinel-compat diff REV_A REV_B [--names]"

        a = {}
        b = {}
        Ledger.new.each do |v|
          a[v.gem] = v.verdict if v.rev.start_with?(rev_a)
          b[v.gem] = v.verdict if v.rev.start_with?(rev_b)
        end
        raise Error, "no entries match REV_A=#{rev_a}" if a.empty?
        raise Error, "no entries match REV_B=#{rev_b}" if b.empty?

        both = a.keys & b.keys
        unchanged = 0
        transitions = Hash.new { |h, k| h[k] = [] }
        both.each do |g|
          if a[g] == b[g] then unchanged += 1
          else transitions["#{a[g]} -> #{b[g]}"] << g
          end
        end

        @out.puts "rev A: #{rev_a} (#{a.size} gems)"
        @out.puts "rev B: #{rev_b} (#{b.size} gems)"
        @out.puts "common: #{both.size} · unchanged: #{unchanged} · changed: #{both.size - unchanged}"
        @out.puts "only in A: #{(a.keys - b.keys).size} · only in B: #{(b.keys - a.keys).size}"
        @out.puts
        transitions.sort_by { |_, gs| -gs.size }.each do |t, gs|
          @out.printf("%-26s %d\n", t, gs.size)
          gs.sort.each { |g| @out.puts "    #{g}" } if names_flag
        end
        0
      end

      # Infer a draft spinel-ext.json from a gem's `ffi_cflags "@PLACEHOLDER@"`
      # declarations + nearby `.c` files. Keeps the C-ext convention strictly
      # consumer-side: gem authors don't have to ship the manifest.
      def cmd_detect_ext(argv)
        require_relative "ext_detector"
        out_file = (j = argv.index("--out")) ? argv.delete_at(j + 1).tap { argv.delete_at(j) } : nil
        dir = argv.shift or raise Error, "usage: spinel-compat detect-ext GEM_DIR [--out FILE]"

        json = ExtDetector.new(File.expand_path(dir)).to_json
        if out_file
          File.write(File.expand_path(out_file), json + "\n")
          @out.puts "wrote #{out_file}"
        else
          @out.puts json
        end
        0
      end

      # Build the spinelgems.org static deploy tree: presentation + ledger-driven
      # catalog, plus the Compact Index (apex double-duty) when a --store is given.
      def cmd_build_site(argv)
        require_relative "site"
        out = (j = argv.index("--out")) ? argv[j + 1] : raise(Error, "build-site needs --out DIR")
        store = (i = argv.index("--store")) ? File.expand_path(argv[i + 1]) : nil
        min = (k = argv.index("--min")) ? argv[k + 1].to_sym : :verified
        # Default to the committed snapshot — survey-193k/ holds compat.jsonl
        # (the ledger backing the deploy) and meta.jsonl (the PG-dump-derived
        # full per-gem metadata, 193k entries). `survey-out/` is a working
        # directory for per-run probes; not what the public catalog renders from.
        ledger_path = (l = argv.index("--ledger")) ? argv[l + 1] : "survey-193k/compat.jsonl"
        meta_path = (m = argv.index("--meta")) ? argv[m + 1] : "survey-193k/meta.jsonl"
        site = Site.new(ledger: Ledger.new(path: File.expand_path(ledger_path)),
                        meta_path: File.expand_path(meta_path))
        dir = site.build(File.expand_path(out), store: store, min_verdict: min)
        @out.puts "built spinelgems.org site -> #{dir}" \
                  "#{store ? " (+ Compact Index from #{store})" : ' (presentation + catalog; pass --store DIR to add the Compact Index)'}"
        0
      end

      # Serve the static site + (with --store) the Compact Index from one process
      # — what the deploy host runs. Port defaults to $PORT (Upsun) then 9292.
      def cmd_server(argv)
        require_relative "server"
        pub = (i = argv.index("--public")) ? argv[i + 1] : "public"
        port = (j = argv.index("--port")) ? argv[j + 1].to_i : Integer(ENV.fetch("PORT", "9292"))
        store = (k = argv.index("--store")) ? File.expand_path(argv[k + 1]) : nil
        min = (m = argv.index("--min")) ? argv[m + 1].to_sym : :verified
        Server.new(public_dir: File.expand_path(pub), store: store, min_verdict: min).run(port: port)
        0
      end

      def cmd_ledger(argv)
        rev = (i = argv.index("--rev")) ? argv[i + 1] : nil
        Ledger.new.each do |v|
          next if rev && v.rev != rev

          print_verdict(v, show_rev: true)
        end
        0
      end

      # Forward-compat sweep: re-probe every gem the ledger has ever seen under
      # the *current* engine rev, surfacing what newly passes after a Spinel
      # upgrade. Skips triples already probed at this rev.
      def cmd_reprobe(_argv)
        engine = Engine.new
        ledger = Ledger.new
        probe = Probe.new(engine, ledger)
        flips = 0
        ledger.known_gems.each do |name, version|
          next if ledger.lookup(name, version, engine.rev)

          dir = GemFetcher.new.fetch(name, version)
          v = probe.probe(name, version, dir)
          flips += 1
          print_verdict(v)
        rescue Error => e
          @err.puts "  ! #{name} #{version}: #{e.message}"
        end
        @out.puts "re-probed #{flips} gem(s) under #{engine.rev}"
        0
      end

      # Wholesale review: probe a list of gems in parallel, then emit a report
      # (the rejection-reason histogram prioritises Spinel's roadmap).
      def cmd_survey(argv)
        jobs = (i = argv.index("--jobs")) ? argv.delete_at(i + 1).to_i.tap { argv.delete_at(i) } : 4
        out_file = (j = argv.index("--out")) ? argv.delete_at(j + 1).tap { argv.delete_at(j) } : nil
        list = (k = argv.index("--list")) ? argv.delete_at(k + 1).tap { argv.delete_at(k) } : nil
        # --refresh: ignore cache hits in the ledger and re-probe every gem.
        # Default (no flag) reuses any existing verdict at the current engine rev
        # — so pointing SPINEL_COMPAT_LEDGER at the canonical ledger gives a
        # cross-run incremental survey (only new gems get the compile cost).
        refresh = !!argv.delete("--refresh")
        names = if list
                  File.readlines(File.expand_path(list)).map(&:strip).reject { |l| l.empty? || l.start_with?("#") }
                else
                  argv.dup
                end
        raise Error, "usage: spinel-compat survey GEM... | --list FILE [--jobs N] [--out report.md] [--refresh]" if names.empty?

        survey = Survey.new(jobs: jobs, refresh: refresh)
        survey.run(names)
        report = survey.report(names)
        if out_file
          out_path = File.expand_path(out_file)
          File.write(out_path, report)
          tsv_path = File.join(File.dirname(out_path), "candidates.tsv")
          File.write(tsv_path, survey.candidates_tsv(names))
          @out.puts "wrote #{out_file} + candidates.tsv (#{names.size} gems)"
        else
          @out.puts report
        end
        0
      end

      def print_verdict(v, show_rev: false)
        glyph = VERDICT_GLYPH[v.verdict] || "?"
        labels = v.reasons + v.risks.map { |r| r.include?(":") ? r : "risk:#{r}" }
        tail = labels.empty? ? "" : " — #{labels.join(', ')}"
        rev = show_rev ? " [#{v.rev}]" : ""
        @out.puts format("  %s %-22s %-10s %-9s%s%s", glyph, v.gem, v.version, v.verdict, tail, rev)
      end

      def latest_version(name)
        require "open3"
        out, st = Open3.capture2e("gem", "list", "-r", "-e", name)
        raise Error, "cannot resolve latest version of #{name}" unless st.success?

        out[/#{Regexp.escape(name)} \(([^,)]+)/, 1] or
          raise Error, "no remote versions found for #{name}"
      end

      def usage
        @out.puts <<~USAGE
          spinel-compat — Spinel gem-compatibility ledger

            spinel-compat engine                 show detected compiler + engine rev
            spinel-compat probe NAME [VERSION]    probe one gem, record a verdict
            spinel-compat verify NAME [--smoke F]  differential CRuby-vs-Spinel run -> verified
            spinel-compat vendor [LOCK] [--into D] place deps where Spinel finds them + deps.rb
            spinel-compat check [LOCK] [--strict] gate a Gemfile.lock (exit 1 if rejected)
            spinel-compat survey GEM... | --list F  wholesale review -> reason histogram
            spinel-compat serve --store DIR        curated source (only vetted gems)
            spinel-compat build-index --store DIR --out DIR   static curated index
            spinel-compat build-site --out DIR [--store DIR]  static site (presentation + catalog [+ index])
            spinel-compat server --public DIR [--store DIR]   serve site + Compact Index (one process; $PORT)
            spinel-compat ledger [--rev REV]      dump recorded verdicts
            spinel-compat diff REV_A REV_B [--names]  per-gem verdict changes between two revs
            spinel-compat detect-ext GEM_DIR [--out F]  draft spinel-ext.json from a gem's ffi_cflags markers
            spinel-compat reprobe                 re-probe known gems under current rev

          Verdicts: ✓ clean   ★ verified   ~ risky   ✗ rejected
        USAGE
      end
    end
  end
end
