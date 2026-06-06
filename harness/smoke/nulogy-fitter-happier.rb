# nulogy-fitter-happier smoke
# This gem is a Rails Engine (requires Rails::Engine at load time).
# We stub the minimal Rails surface to allow loading, then exercise
# the module structure provided by the gem.

# Minimal Rails stub — the gem calls these at require time
module Rails
  class Engine
    def self.inherited(subclass); end
    def self.isolate_namespace(mod); end
    def self.config
      cfg = Object.new
      def cfg.generators
        gen = Object.new
        def gen.test_framework(*); end
        def gen.assets(*); end
        def gen.helper(*); end
        yield gen if block_given?
      end
      cfg
    end
  end
end

require 'fitter_happier'

# Verify the FitterHappier module and Engine were defined
puts FitterHappier.class                    # => Module
puts FitterHappier::Engine.superclass       # => Rails::Engine

# Derive gem root from the load path entry that holds fitter_happier.rb
fitter_lib = $LOAD_PATH.find { |p| File.exist?("#{p}/fitter_happier.rb") }
gem_root   = File.dirname(fitter_lib)       # one level up from lib/

load "#{gem_root}/app/helpers/fitter_happier/database_check.rb"
load "#{gem_root}/app/helpers/fitter_happier/new_relic_adapter.rb"

# DatabaseCheck is a module with a singleton method :schema_version
puts FitterHappier::DatabaseCheck.respond_to?(:schema_version)    # => true
puts FitterHappier::DatabaseCheck.singleton_class
  .instance_method(:schema_version).arity                         # => 0

# NewRelicAdapter is a module with a singleton method :ignore_transaction
puts FitterHappier::NewRelicAdapter.respond_to?(:ignore_transaction)  # => true
puts FitterHappier::NewRelicAdapter.singleton_class
  .instance_method(:ignore_transaction).arity                         # => 0

# Module names are correctly namespaced
puts FitterHappier::DatabaseCheck.name     # => FitterHappier::DatabaseCheck
puts FitterHappier::NewRelicAdapter.name   # => FitterHappier::NewRelicAdapter
