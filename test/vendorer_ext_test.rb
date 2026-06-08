#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Regression coverage for Vendorer#wire_extensions — the spinel-ext.json
# manifest processor (spinelgems#2, #8, #14, #15). The corpus-probe harness
# tests gem *compilation*; this tests the *vendorer's* manifest handling, which
# tep (per-.c shims) and toy (build-units) both ride and which had zero
# automated coverage before #15.
#
# Framework-free + hermetic: synthetic fixtures, the system `cc`/`make`, and
# `pkg-config zlib` (present on every CI runner) — never the sibling projects'
# trees. Run: `ruby test/vendorer_ext_test.rb` (exit 0 = all pass).
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "json"
require "fileutils"
require "tmpdir"
require "stringio"
require "bundler/spinel"

@fails = 0
def check(cond, msg)
  puts((cond ? "  PASS  " : "  FAIL  ") + msg)
  @fails += 1 unless cond
end

def section(name)
  puts "\n#{name}"
  yield
end

# Capture $stderr around a block (the vendorer warns there).
def capture_stderr
  prev = $stderr
  $stderr = StringIO.new
  yield
  $stderr.string
ensure
  $stderr = prev
end

def vendorer
  Bundler::Spinel::Vendorer.new
end

# ---------------------------------------------------------------------------
# 1. Per-.c path (tep's shape): source compile + placeholder substitution +
#    a CFLAGS-only pkg_config sibling folded into its source-entry compile (#8).
# ---------------------------------------------------------------------------
section "per-.c source compile + placeholder + pkg_config sibling fold (tep shape)" do
  Dir.mktmpdir("vendorer-ext") do |src|
    FileUtils.mkdir_p(File.join(src, "lib", "fixt"))
    File.write(File.join(src, "lib/fixt/shim.c"), "int fixt_answer(void){return 42;}\n")
    File.write(File.join(src, "lib/fixt/db.c"),   "int fixt_db(void){return 1;}\n")
    File.write(File.join(src, "lib/fixt/ffi.rb"),
               %(ffi_cflags "@FIXT_SHIM_O@"\nffi_cflags "@FIXT_DB_O@"\nffi_cflags "@FIXT_DB_CFLAGS@"\n))
    File.write(File.join(src, "spinel-ext.json"), JSON.dump([
      { "name" => "shim", "placeholder" => "@FIXT_SHIM_O@", "source" => "lib/fixt/shim.c", "cflags" => ["-O2"] },
      { "name" => "db",   "placeholder" => "@FIXT_DB_O@",   "source" => "lib/fixt/db.c",   "cflags" => ["-O2"] },
      { "name" => "db",   "placeholder" => "@FIXT_DB_CFLAGS@", "pkg_config" => "zlib", "pkg_config_fallback" => "-lz" },
    ]))

    wired = vendorer.send(:wire_extensions, src, src, {}, [])
    check(wired == 3, "wired #{wired} entries (expected 3)")
    body = File.read(File.join(src, "lib/fixt/ffi.rb"))
    %w[@FIXT_SHIM_O@ @FIXT_DB_O@ @FIXT_DB_CFLAGS@].each { |ph| check(!body.include?(ph), "#{ph} substituted") }
    check(File.exist?(File.join(src, "lib/fixt/shim.o")), "shim.o compiled")
    check(File.exist?(File.join(src, "lib/fixt/db.o")),   "db.o compiled (sibling pkg_config cflags folded)")
  end
end

# ---------------------------------------------------------------------------
# 2. build-unit path (#14, toy's shape): a make unit producing a .a, {dir} and
#    cross-entry {dir:NAME} link expansion, artifact verification.
# ---------------------------------------------------------------------------
section "build-unit: make archive + {dir}/{dir:NAME} link expansion + artifact check (#14)" do
  Dir.mktmpdir("vendorer-bu") do |src|
    FileUtils.mkdir_p(File.join(src, "lib"))
    FileUtils.mkdir_p(File.join(src, "core"))
    FileUtils.mkdir_p(File.join(src, "shim"))
    File.write(File.join(src, "core/c.c"), "int core_v(void){return 1;}\n")
    File.write(File.join(src, "core/Makefile"),
               "libcore.a: c.o\n\tar rcs $@ $<\nc.o: c.c\n\t$(CC) -c $< -o $@\n")
    File.write(File.join(src, "shim/s.c"), "int shim_v(void){return 2;}\n")
    File.write(File.join(src, "shim/Makefile"),
               "libshim.a: s.o\n\tar rcs $@ $<\ns.o: s.c\n\t$(CC) -c $< -o $@\n")
    File.write(File.join(src, "lib/ffi.rb"), %(ffi_cflags "@BU_LINK@"\n))
    File.write(File.join(src, "spinel-ext.json"), JSON.dump([
      { "name" => "core",
        "build" => { "tool" => "make", "dir" => "core", "artifacts" => ["libcore.a"] } },
      { "name" => "shim",
        "build" => { "tool" => "make", "dir" => "shim", "artifacts" => ["libshim.a"] },
        "placeholder" => "@BU_LINK@",
        "link" => ["-L{dir}", "-L{dir:core}", "-lshim", "-lcore"] },
    ]))

    dest = File.join(src, "_vendored")
    FileUtils.mkdir_p(File.join(dest, "lib"))
    FileUtils.cp(File.join(src, "lib/ffi.rb"), File.join(dest, "lib/ffi.rb"))
    wired = vendorer.send(:wire_extensions, src, dest, {}, [])
    check(wired == 2, "build-unit wired #{wired} entries (expected 2)")
    check(File.exist?(File.join(dest, "core/libcore.a")), "core/libcore.a built in vendor tree")
    check(File.exist?(File.join(dest, "shim/libshim.a")), "shim/libshim.a built in vendor tree")
    line = File.read(File.join(dest, "lib/ffi.rb"))
    check(line.include?("-L#{dest}/shim") || line.include?("-L#{File.join(dest, 'shim').sub(Dir.pwd + '/', '')}"),
          "{dir} expanded to shim's vendored dir")
    check(line.include?("shim") && line.include?("core") && !line.include?("{dir"),
          "{dir:core} cross-entry reference resolved (#{line.strip})")
  end
end

# ---------------------------------------------------------------------------
# 3. SPINEL_EXT_* override skips the build (prebuilt escape hatch, #14).
# ---------------------------------------------------------------------------
section "build-unit: SPINEL_EXT_* override substitutes flags + skips the build (#14)" do
  Dir.mktmpdir("vendorer-ov") do |src|
    FileUtils.mkdir_p(File.join(src, "lib"))
    FileUtils.mkdir_p(File.join(src, "core"))
    # A Makefile that would FAIL if run — proves the build was skipped.
    File.write(File.join(src, "core/Makefile"), "all:\n\tfalse\n")
    File.write(File.join(src, "lib/ffi.rb"), %(ffi_cflags "@OV_LINK@"\n))
    File.write(File.join(src, "spinel-ext.json"), JSON.dump([
      { "name" => "core",
        "build" => { "tool" => "make", "dir" => "core", "artifacts" => ["libcore.a"] },
        "placeholder" => "@OV_LINK@", "link" => ["-L{dir}", "-lcore"] },
    ]))
    dest = File.join(src, "_vendored")
    FileUtils.mkdir_p(File.join(dest, "lib"))
    FileUtils.cp(File.join(src, "lib/ffi.rb"), File.join(dest, "lib/ffi.rb"))

    ENV["SPINEL_EXT_OV_LINK"] = "-L/opt/prebuilt -lcore"
    begin
      wired = vendorer.send(:wire_extensions, src, dest, {}, [])
    ensure
      ENV.delete("SPINEL_EXT_OV_LINK")
    end
    check(wired == 1, "override wired #{wired} (expected 1)")
    body = File.read(File.join(dest, "lib/ffi.rb"))
    check(body.include?("-L/opt/prebuilt -lcore"), "override flags substituted")
    check(!File.exist?(File.join(dest, "core")), "build skipped (failing Makefile never ran)")
  end
end

# ---------------------------------------------------------------------------
# 4. Zero-substitution drift warning (toy#45): a placeholder absent from the
#    vendored .rb warns loud (replaces per-gem cflags canaries).
# ---------------------------------------------------------------------------
section "drift: a placeholder matching no vendored .rb warns (toy#45)" do
  Dir.mktmpdir("vendorer-drift") do |src|
    FileUtils.mkdir_p(File.join(src, "lib"))
    File.write(File.join(src, "lib/c.c"), "int v(void){return 1;}\n")
    File.write(File.join(src, "lib/ffi.rb"), %(ffi_cflags "this line moved"\n)) # placeholder NOT present
    File.write(File.join(src, "spinel-ext.json"), JSON.dump([
      { "name" => "c", "placeholder" => "@GONE@", "source" => "lib/c.c" },
    ]))
    dest = File.join(src, "_vendored")
    FileUtils.mkdir_p(File.join(dest, "lib"))
    FileUtils.cp(File.join(src, "lib/ffi.rb"), File.join(dest, "lib/ffi.rb"))
    err = capture_stderr { vendorer.send(:wire_extensions, src, dest, {}, []) }
    check(err.include?("matched NO vendored"), "drift warning emitted (#{err.strip.split("\n").last})")
  end
end

# ---------------------------------------------------------------------------
# 5. optional + disable -> disabled_cflags (tep's NO_SQLITE shape).
# ---------------------------------------------------------------------------
section "optional entry opted out substitutes disabled_cflags" do
  Dir.mktmpdir("vendorer-opt") do |src|
    FileUtils.mkdir_p(File.join(src, "lib"))
    File.write(File.join(src, "lib/ffi.rb"), %(ffi_cflags "@OPT@"\n))
    File.write(File.join(src, "spinel-ext.json"), JSON.dump([
      { "name" => "feat", "placeholder" => "@OPT@", "source" => "lib/none.c",
        "optional" => true, "disabled_cflags" => "-DNO_FEAT" },
    ]))
    dest = File.join(src, "_vendored")
    FileUtils.mkdir_p(File.join(dest, "lib"))
    FileUtils.cp(File.join(src, "lib/ffi.rb"), File.join(dest, "lib/ffi.rb"))
    wired = vendorer.send(:wire_extensions, src, dest, {}, ["feat"])
    check(wired == 1, "opted-out entry wired #{wired} (expected 1)")
    body = File.read(File.join(dest, "lib/ffi.rb"))
    check(body.include?("-DNO_FEAT"), "disabled_cflags substituted (build skipped)")
  end
end

puts(@fails.zero? ? "\nALL PASS" : "\n#{@fails} FAILURE(S)")
exit(@fails.zero? ? 0 : 1)
