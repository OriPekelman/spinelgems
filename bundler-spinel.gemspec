require_relative "lib/bundler/spinel/version"

Gem::Specification.new do |s|
  s.name        = "bundler-spinel"
  s.version     = Bundler::Spinel::VERSION
  s.summary     = "Resolution-time gem-compatibility gating for the Spinel Ruby AOT compiler"
  s.description = "A Bundler plugin + CLI that probes whether gems compile under " \
                  "Spinel and gates `bundle lock` on a forward-compatible, " \
                  "engine-rev-keyed compatibility ledger."
  s.authors     = ["Ori Pekelman"]
  s.license     = "MIT"
  s.required_ruby_version = ">= 3.0"

  s.files = Dir["lib/**/*.rb", "exe/*", "plugins.rb", "*.md"]
  s.bindir      = "exe"
  s.executables = ["spinel-compat"]
  s.require_paths = ["lib"]

  # Bundler is the host; no other runtime deps (stdlib + `gem` CLI only).
end
