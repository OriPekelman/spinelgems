require "net/http"
require "json"
require "cgi"

module Bundler
  module Spinel
    # Fetches public gem metadata from rubygems.org (description, total downloads,
    # latest version + date, homepage, license) for a list of gems, into a
    # sidecar meta.jsonl — one JSON line per gem. The catalog uses it to be
    # enticing (real descriptions, sort by popularity) and to weed out low-signal
    # / test gems by a downloads floor.
    #
    # Append-only and resumable: a re-run skips gems already recorded, so a flaky
    # network just needs another pass. Transient (non-200/404) responses are left
    # unrecorded so the next run retries them. Committed alongside the survey, so
    # the deploy build renders the catalog offline — no network at build time.
    class Enricher
      HOST = "rubygems.org"

      def initialize(out:, jobs: 8)
        @out = out
        @jobs = jobs
        @write = Mutex.new
      end

      # names: Array<String>. Appends one JSON line per newly-fetched gem.
      def run(names, progress: $stderr)
        have = existing
        todo = names.uniq.reject { |n| have.include?(n) }
        queue = Queue.new
        todo.each { |n| queue << n }
        total = todo.size
        done = 0
        progress&.puts("[enrich] #{have.size} already recorded, #{total} to fetch")

        File.open(@out, "a") do |f|
          workers = Array.new([@jobs, [total, 1].max].min) do
            Thread.new do
              http = open_http
              until queue.empty?
                name = (queue.pop(true) rescue break)
                rec = fetch(http, name)
                @write.synchronize do
                  f.puts(JSON.generate(rec)) && f.flush if rec
                  done += 1
                  progress&.print("\r[enrich] #{done}/#{total}  #{name.ljust(30)}")
                end
              end
              http.finish if http.started?
            end
          end
          workers.each(&:join)
        end
        progress&.puts("\r[enrich] #{done}/#{total} done#{' ' * 30}")
      end

      private

      def open_http
        http = Net::HTTP.new(HOST, 443)
        http.use_ssl = true
        http.open_timeout = 10
        http.read_timeout = 20
        http.keep_alive_timeout = 30
        http.start
        http
      end

      def fetch(http, name)
        res = http.get("/api/v1/gems/#{CGI.escape(name)}.json")
        case res.code.to_i
        when 200
          h = JSON.parse(res.body)
          {
            "gem"       => name,
            "downloads" => h["downloads"],
            "info"      => h["info"],
            "version"   => h["version"],
            "updated"   => h["version_created_at"],
            "homepage"  => h["homepage_uri"] || h["source_code_uri"] || h["project_uri"],
            "licenses"  => h["licenses"],
            "yanked"    => h["yanked"]
          }
        when 404
          { "gem" => name, "missing" => true }
        end # any other code: nil -> not recorded, retried next run
      rescue StandardError
        nil
      end

      def existing
        seen = {}
        return seen unless File.exist?(@out)

        File.foreach(@out) do |line|
          line = line.strip
          next if line.empty?

          begin
            g = JSON.parse(line)["gem"]
            seen[g] = true if g
          rescue JSON::ParserError
            next
          end
        end
        seen
      end
    end
  end
end
