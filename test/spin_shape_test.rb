#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Spin package shape support (spin.toml at the root, <name>.rb + <name>/
# instead of lib/): the verifier's entrypoint/require-tree/CRuby-load-path
# and the probe's entrypoints/static-scan must all resolve the root layout.
# Motivated by spinel_kit 0.3.0 (post-`spinel-compat port`), which the
# rubygems-layout assumptions mis-verified as a build-error. Hermetic — no
# engine. Run: `ruby test/spin_shape_test.rb`.
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fileutils"
require "tmpdir"
require "bundler/spinel"
require "bundler/spinel/verifier"
require "bundler/spinel/probe"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

def mk_spin_pkg(dir)
  File.write(File.join(dir, "spin.toml"), %([package]\nname = "demo_kit"\nversion = "0.1.0"\n))
  File.write(File.join(dir, "demo_kit.rb"), %(require_relative "demo_kit/core"\n))
  FileUtils.mkdir_p(File.join(dir, "demo_kit"))
  File.write(File.join(dir, "demo_kit", "core.rb"),
             "module DemoKit\n  def self.greet = \"hi\"\nend\n")
  # harness legs that must NOT be force-required or scanned as shipped code
  FileUtils.mkdir_p(File.join(dir, "test"))
  File.write(File.join(dir, "test", "demo_test.rb"), "eval('1')\n")
end

v = Bundler::Spinel::Verifier.allocate
p_ = Bundler::Spinel::Probe.allocate

puts "verifier: spin-shape entrypoint / require tree / CRuby load path"
Dir.mktmpdir("spinpkg") do |dir|
  mk_spin_pkg(dir)
  check(v.send(:spin_shape?, dir), "spin.toml -> spin_shape?")
  check(v.send(:entrypoint, "demo_kit", dir) == "demo_kit", "entrypoint = root demo_kit")
  check(v.send(:entrypoint, "demo-kit", dir) == "demo_kit", "dashed name maps to underscore root")
  reqs = v.send(:lib_requires, dir, "demo_kit")
  check(reqs.first == "demo_kit", "entry first in require tree")
  check(reqs.include?("demo_kit/core"), "package subdir files force-required")
  check(reqs.none? { |r| r.start_with?("test") }, "test/ leg excluded from require tree")
  src = v.send(:harness_source, "demo_kit", dir, nil, true)
  check(src.include?(%(require_relative "demo_kit")), "harness requires the root entry")
  out, _err, ok = v.send(:run_ruby, File.join(dir, "demo_kit.rb"), dir)
  check(ok && out.empty?, "CRuby leg loads with the package root on -I")
end

puts "probe: spin-shape entrypoints + static scan sources"
Dir.mktmpdir("spinpkg") do |dir|
  mk_spin_pkg(dir)
  eps = p_.send(:entrypoints, dir, "demo_kit")
  check(eps == [File.join(dir, "demo_kit.rb")], "entrypoints = root demo_kit.rb")
  files = p_.send(:source_files, dir, "demo_kit")
  check(files.include?(File.join(dir, "demo_kit", "core.rb")), "scan covers package subdir")
  check(files.none? { |f| f.include?("/test/") }, "scan skips test/ leg")
  risks = p_.send(:static_signal, dir, "demo_kit")
  check(!risks.include?("eval"), "test-leg eval not misattributed to shipped code")
end

puts "rubygems shape unchanged"
Dir.mktmpdir("gempkg") do |dir|
  FileUtils.mkdir_p(File.join(dir, "lib"))
  File.write(File.join(dir, "lib", "classic.rb"), "module Classic; end\n")
  check(!v.send(:spin_shape?, dir), "no spin.toml -> rubygems shape")
  check(v.send(:entrypoint, "classic", dir) == "lib/classic", "lib entrypoint unchanged")
  check(p_.send(:entrypoints, dir, "classic") == [File.join(dir, "lib", "classic.rb")],
        "probe lib entrypoints unchanged")
end

puts(@fails.zero? ? "all checks passed" : "#{@fails} FAILED")
exit(@fails.zero? ? 0 : 1)
