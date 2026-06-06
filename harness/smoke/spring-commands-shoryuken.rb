# Smoke: spring-commands-shoryuken
# Exercises Spring::Commands::Shoryuken command class methods and Shoryuken::CLI stub.
# Uses BEGIN{} to define the Spring stub before any require_relative inlining in --full mode.

BEGIN {
  # Stub Spring.register_command so lib/spring/commands/shoryuken.rb loads
  # cleanly whether executed standalone or inlined by the harness --full pass.
  module Spring
    module Commands; end
    def self.register_command(name, obj)
      @registered ||= {}
      @registered[name] = obj
    end
    def self.registered
      @registered ||= {}
    end
  end
}

require 'spring/commands/shoryuken'

# 1. Shoryuken::CLI stub was defined by the gem
puts Shoryuken::CLI.is_a?(Module) ? "Shoryuken::CLI is a Module" : "FAIL: Shoryuken::CLI"

# 2. VERSION constant
puts "VERSION=#{Spring::Commands::Shoryuken::VERSION}"

# 3. Instantiate and exercise #env (accepts splat args, always returns "development")
cmd = Spring::Commands::Shoryuken.new
puts "env()=#{cmd.env}"
puts "env(ignored)=#{cmd.env('production')}"

# 4. exec_name returns the command name
puts "exec_name=#{cmd.exec_name}"

# 5. Registration recorded via our stub
registered = Spring.registered['shoryuken']
puts "registered class=#{registered.class}"
puts "registered exec_name=#{registered.exec_name}"
