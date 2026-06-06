# frozen_string_literal: true
# Smoke: binaryen — WebAssembly toolkit Ruby wrapper
# Tests: version constants, path helpers, error hierarchy, Command constants + ignore_missing init

require "binaryen"

# Version constants
puts Binaryen::VERSION
puts Binaryen::BINARYEN_VERSION

# Path helpers: vendordir/bindir/libdir/includedir all return strings ending in expected segments
cpu = RbConfig::CONFIG["host_cpu"]
os_raw = RbConfig::CONFIG["host_os"]
os = os_raw.include?("darwin") ? "darwin" : os_raw
expected_suffix = "#{cpu}-#{os}"

vdir = Binaryen.vendordir
puts vdir.end_with?(expected_suffix) ? "vendordir:ok" : "vendordir:bad"
puts Binaryen.bindir  == File.join(vdir, "bin")     ? "bindir:ok"     : "bindir:bad"
puts Binaryen.libdir  == File.join(vdir, "lib")     ? "libdir:ok"     : "libdir:bad"
puts Binaryen.includedir == File.join(vdir, "include") ? "includedir:ok" : "includedir:bad"

# Error class hierarchy
puts Binaryen::Error.ancestors.include?(StandardError)          ? "error-base:ok"  : "error-base:bad"
puts Binaryen::NonZeroExitStatus.ancestors.include?(Binaryen::Error) ? "non-zero:ok"  : "non-zero:bad"
puts Binaryen::MaximumOutputExceeded.ancestors.include?(Binaryen::Error) ? "max-exceeded:ok" : "max-exceeded:bad"
puts Binaryen::Signal.ancestors.include?(Binaryen::Error)       ? "signal:ok"      : "signal:bad"

# Command class constants
puts Binaryen::Command::DEFAULT_TIMEOUT
puts Binaryen::Command::DEFAULT_MAX_OUTPUT_SIZE

# Command raises ArgumentError for missing binary (no ignore_missing)
begin
  Binaryen::Command.new("no-such-tool")
  puts "missing-raise:bad"
rescue ArgumentError => e
  puts e.message.start_with?("command not found") ? "missing-raise:ok" : "missing-raise:bad"
end

# Command.new with ignore_missing: true falls back to the command string
cmd = Binaryen::Command.new("wasm-opt", ignore_missing: true)
puts cmd.class
