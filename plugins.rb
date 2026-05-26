# Bundler plugin entry point. Read by Bundler when this gem is installed as a
# plugin (`bundle plugin install bundler-spinel`). Registers the gate commands.
require_relative "lib/bundler/spinel/command"

Bundler::Plugin::API.command("spinel-lock", Bundler::Spinel::Command)
Bundler::Plugin::API.command("spinel-check", Bundler::Spinel::Command)
