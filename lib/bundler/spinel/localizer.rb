require "open3"
require "json"

module Bundler
  module Spinel
    # Upgrades a bare `miscompile` verdict (CRuby and Spinel agree to run but
    # disagree on stdout) into a *located* one: the (file, line, variable) where
    # a scalar local first diverges — via the value-bisection harness that lives
    # in the spinel-dev repo (tools/value-bisect/bisect.sh).
    #
    # Why: a miscompile reason of `diff:L2 cruby="42" spinel="0"` says two outputs
    # differ but not *why*. The bisector traces every scalar local under both
    # CRuby and a Spinel --debug build and reports the first to part ways, turning
    # that into `localized:foo.rb:12 total cruby=42 spinel=0` — a line to look at.
    #
    # Strictly best-effort and non-fatal. If the harness can't be found (it's a
    # separate repo), can't run (the engine dir is a bare binary with no compiler
    # sources / no lldb), or can't pin a scalar (the divergence is in output
    # formatting, not a traced local), verify still returns the miscompile verdict
    # unchanged — this only ever *adds* a `localized:` reason when it has one.
    class Localizer
      def initialize(engine)
        @engine = engine
      end

      # Run the bisector on `harness` (a self-contained .rb; require_relative'd
      # files are traced too) and return a short reason string, or nil when
      # localization isn't possible or didn't pin a value.
      def localize(harness)
        script = bisect_script or return nil
        # SPINEL_DIR points the bisector at the same compiler the engine uses;
        # it shells out to that checkout's spinel_analyze.rb / spinel_codegen.rb.
        # bisect.sh exits 1 *on divergence* (the case we want), so the exit code
        # is not a success signal — parse stdout regardless. stdout carries only
        # the single JSON object in --json mode; progress goes to stderr.
        out, _err, _st = Open3.capture3(
          { "SPINEL_DIR" => @engine.dir }, "sh", script, "--json", harness
        )
        line = out.lines.map(&:strip).reject(&:empty?).last or return nil
        verdict = begin
          JSON.parse(line)
        rescue JSON::ParserError
          return nil
        end
        format_verdict(verdict)
      rescue StandardError
        nil
      end

      private

      def format_verdict(v)
        case v["verdict"]
        when "diverge"
          "localized:#{loc(v)} #{v['variable']} cruby=#{v['cruby']} spinel=#{v['spinel']}"
        when "crash"
          "localized:crash@#{loc(v)} signal=#{v['signal']}"
        end
        # Any other verdict (ok / exit-differ / abort) means the bisector couldn't
        # attribute the divergence to a traced scalar; leave the verdict un-enriched.
      end

      def loc(v)
        file = v["file"].to_s
        file.empty? ? "line #{v['line']}" : "#{file}:#{v['line']}"
      end

      # Resolve bisect.sh. It lives in the spinel-dev tooling repo (separate from
      # the compiler engine), so there's no fixed relation to the engine dir —
      # probe a few conventional spots, newest-intent first: an explicit override,
      # a sibling checkout next to the engine, the conventional ~/sites layout.
      # The local checkout may be named spinel-tools (gx10) or spinel-dev (the
      # GitHub repo name), so probe both.
      def bisect_script
        rel = "tools/value-bisect/bisect.sh"
        candidates = [ENV["SPINEL_BISECT"]]
        %w[spinel-tools spinel-dev].each do |repo|
          candidates << File.expand_path(File.join(@engine.dir, "..", repo, rel))
          candidates << File.expand_path("~/sites/#{repo}/#{rel}")
        end
        candidates.find { |c| c && File.exist?(c) }
      end
    end
  end
end
