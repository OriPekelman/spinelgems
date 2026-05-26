require_relative "../spinel"

module Bundler
  module Spinel
    # Thin command dispatcher shared by the `spinel-compat` executable and the
    # Bundler plugin command. Keeps all logic in the library classes.
    class CLI
      VERDICT_GLYPH = {
        "clean" => "✓", "verified" => "★", "risky" => "~", "rejected" => "✗"
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
        when "check"   then cmd_check(argv)
        when "ledger"  then cmd_ledger(argv)
        when "reprobe" then cmd_reprobe(argv)
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
            spinel-compat check [LOCK] [--strict] gate a Gemfile.lock (exit 1 if rejected)
            spinel-compat ledger [--rev REV]      dump recorded verdicts
            spinel-compat reprobe                 re-probe known gems under current rev

          Verdicts: ✓ clean   ★ verified   ~ risky   ✗ rejected
        USAGE
      end
    end
  end
end
