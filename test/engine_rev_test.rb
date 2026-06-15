#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Coverage for Engine#rev provenance (the ledger key). Two cases that used to
# fall back to an opaque `bin:<hash>` and break cross-rev tooling
# (history/diff): a git *worktree* (where `.git` is a file, not a dir) and a
# frozen/detached engine copy carrying a `.spinel_rev` stamp. Hermetic: fake
# engine dirs, no real compiler. Run: `ruby test/engine_rev_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fileutils"
require "tmpdir"
require "bundler/spinel"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

E = Bundler::Spinel::Engine

# A `.spinel_rev` stamp wins and yields git:<short-sha> regardless of git state.
puts "frozen copy with .spinel_rev stamp -> git:<sha>"
Dir.mktmpdir("eng-stamp") do |dir|
  File.write(File.join(dir, "spinel"), "x"); File.chmod(0o755, File.join(dir, "spinel"))
  File.write(File.join(dir, ".spinel_rev"), "b60fbd7\n")
  rev = E.new(dir: dir).send(:compute_rev)
  check(rev == "git:b60fbd7", "stamp -> #{rev.inspect}")

  # An over-long (full) sha is truncated, never emitted raw.
  File.write(File.join(dir, ".spinel_rev"), "b60fbd779a76d3f2e98bd39e87f2f91dfe4cd890\n")
  rev = E.new(dir: dir).send(:compute_rev)
  check(rev.start_with?("git:") && rev.length <= "git:".length + 12,
        "full sha truncated (#{rev})")
end

# No stamp, no .git, but a binary present -> bin:<hash> (unchanged fallback).
puts "\nno stamp, no .git -> bin:<hash> fallback"
Dir.mktmpdir("eng-bin") do |dir|
  File.write(File.join(dir, "spinel"), "#!/bin/sh\n"); File.chmod(0o755, File.join(dir, "spinel"))
  rev = E.new(dir: dir).send(:compute_rev)
  check(rev.start_with?("bin:"), "binary hash fallback (#{rev})")
end

# A worktree `.git` *file* (gitdir pointer) is honored like a real repo: with no
# resolvable git here we can't assert the sha, but compute_rev must at least
# attempt git (File.exist?, not File.directory?) — proven by the stamp path
# above taking precedence and the bin: fallback only when .git is absent. The
# regression we lock in: a `.git` *file* present + no stamp must NOT silently
# bin: when git can resolve. Emulate with a tiny fake `git` on PATH.
puts "\nworktree .git file -> git: (fake git resolves the sha)"
Dir.mktmpdir("eng-wt") do |dir|
  File.write(File.join(dir, "spinel"), "x"); File.chmod(0o755, File.join(dir, "spinel"))
  File.write(File.join(dir, ".git"), "gitdir: /elsewhere/.git/worktrees/x\n")
  bin = File.join(dir, "fakebin")
  FileUtils.mkdir_p(bin)
  File.write(File.join(bin, "git"), <<~SH)
    #!/bin/sh
    case "$*" in
      *rev-parse*) echo deadbee ;;
      *status*) ;;            # clean
    esac
  SH
  File.chmod(0o755, File.join(bin, "git"))
  old = ENV["PATH"]
  begin
    ENV["PATH"] = "#{bin}:#{old}"
    rev = E.new(dir: dir).send(:compute_rev)
    check(rev == "git:deadbee", "worktree .git file resolved (#{rev})")
  ensure
    ENV["PATH"] = old
  end
end

puts(@fails.zero? ? "\nall checks passed" : "\n#{@fails} check(s) FAILED")
exit(@fails.zero? ? 0 : 1)
