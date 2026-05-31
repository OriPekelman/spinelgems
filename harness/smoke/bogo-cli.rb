# Bogo::Cli module structure - pure entry-file API, no external deps
puts Bogo::Cli.is_a?(Module)
puts Bogo::Cli.respond_to?(:exit_on_signal)
puts Bogo::Cli.respond_to?(:exit_on_signal=)
puts Bogo::Cli.exit_on_signal.nil?
Bogo::Cli.exit_on_signal = false
puts Bogo::Cli.exit_on_signal
Bogo::Cli.exit_on_signal = true
puts Bogo::Cli.exit_on_signal
