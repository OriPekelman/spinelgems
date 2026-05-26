require "open3"
require "tmpdir"
require "fileutils"

module Bundler
  module Spinel
    # Downloads and unpacks a gem's *source* so the probe can compile it.
    # Reuses RubyGems' own `gem fetch` / `gem unpack` — we want the source tree,
    # not an install. Sources are cached under a content dir so re-probes are
    # free.
    class GemFetcher
      CACHE = File.expand_path("~/.cache/spinel-compat/gems")

      def initialize(cache: CACHE)
        @cache = cache
      end

      # Returns the path to the unpacked gem dir, fetching+unpacking if needed.
      def fetch(name, version)
        dest = File.join(@cache, "#{name}-#{version}")
        return dest if File.directory?(dest)

        FileUtils.mkdir_p(@cache)
        Dir.mktmpdir do |tmp|
          out, st = Open3.capture2e(
            "gem", "fetch", name, "-v", version, "--platform", "ruby",
            chdir: tmp
          )
          raise Error, "gem fetch #{name} #{version} failed:\n#{out}" unless st.success?

          gemfile = Dir[File.join(tmp, "#{name}-*.gem")].first
          raise Error, "no .gem produced for #{name} #{version}" unless gemfile

          out, st = Open3.capture2e("gem", "unpack", gemfile, "--target", @cache)
          raise Error, "gem unpack failed:\n#{out}" unless st.success?
        end
        # `gem unpack` may name the dir with a platform suffix; normalise.
        return dest if File.directory?(dest)

        actual = Dir[File.join(@cache, "#{name}-#{version}*")].find { |d| File.directory?(d) }
        actual or raise Error, "unpacked dir for #{name} #{version} not found"
      end
    end
  end
end
