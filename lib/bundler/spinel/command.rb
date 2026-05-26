require_relative "../spinel"
require_relative "cli"

module Bundler
  module Spinel
    # Bundler plugin command. Registered in ../../../plugins.rb so that, once
    # installed via `bundle plugin install bundler-spinel`, these run as
    # first-class bundler subcommands:
    #
    #   bundle spinel-lock   # `bundle lock`, then gate the resulting lockfile
    #   bundle spinel-check  # gate an existing Gemfile.lock
    #
    # `spinel-lock` is the headline: it makes the Spinel-incompatibility failure
    # land at resolution time. `bundle lock` itself ignores the `engine: spinel`
    # directive (it resolves fine); the engine guard only fires at `bundle
    # install`. This wraps lock so the *compatibility* gate fires immediately
    # after resolution instead of waiting for a compile that may silently
    # mis-emit rather than fail.
    class Command < Bundler::Plugin::API
      def exec(command, args)
        cli = CLI.new
        case command
        when "spinel-lock"
          unless system("bundle", "lock", *args)
            exit($?.exitstatus.nonzero? || 1)
          end
          exit cli.run(["check", "Gemfile.lock"])
        when "spinel-check"
          exit cli.run(["check", *args])
        else
          warn "bundler-spinel: unknown command #{command}"
          exit 2
        end
      end
    end
  end
end
