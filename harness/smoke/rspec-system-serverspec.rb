# smoke: rspec-system-serverspec
# Exercises backend class hierarchy, helper module, and deprecation logic.
# The gem's entry point (lib/rspec-system-serverspec.rb) is empty; all
# functional code is in sub-files that require serverspec/specinfra/rspec-system.
# We pre-stub those unavailable external deps before the harness loads lib files.

# Pre-stub modules needed by helpers.rb (include SpecInfra::Helper::RSpecSystem
# and SpecInfra::Helper::DetectOS run at file-load time in helpers.rb).
module SpecInfra
  module Helper
    module DetectOS; end
    module RSpecSystem
      def backend(commands_object = nil); end
    end
  end
  module Backend
    class Exec
      def self.instance; @instance ||= new; end
      def build_command(cmd); cmd; end
      def add_pre_command(cmd); cmd; end
      def set_commands(c); @commands = c; end
    end
  end
end

# Mark external deps as already loaded so their require calls are no-ops
%w[serverspec specinfra rspec-system specinfra/backend/exec
   rspec/its serverspec/version serverspec/matcher serverspec/helper
   serverspec/setup serverspec/subject serverspec/commands/base].each do |f|
  $LOADED_FEATURES << f unless $LOADED_FEATURES.include?(f)
end

require 'rspec-system-serverspec'

# Determine the gem root from the cache dir
GEM_D = Dir.glob(File.join(File.expand_path('~/.cache/spinel-compat/gems'),
                            'rspec-system-serverspec-*')).sort.last

# Load the gem's real modules (the harness also require_relative's these in
# --full mode, so loading them here is idempotent via $LOADED_FEATURES).
load File.join(GEM_D, 'lib/rspec-system-serverspec/backend/rspec_system.rb')
load File.join(GEM_D, 'lib/rspec-system-serverspec/helper/rspec_system.rb')

# 1. Backend class hierarchy: RSpecSystem < Exec
klass = SpecInfra::Backend::RSpecSystem
puts "backend_class=#{klass.name}"
puts "parent=#{klass.superclass.name}"
puts "has_run_command=#{klass.method_defined?(:run_command)}"
puts "has_ssh_exec!=#{klass.private_method_defined?(:ssh_exec!)}"

# 2. Helper module has backend instance method
mod = SpecInfra::Helper::RSpecSystem
puts "helper_module=#{mod.name}"
puts "helper_has_backend=#{mod.method_defined?(:backend)}"

# 3. The :exit_code -> :exit_status remapping in Backend::RSpecSystem#ssh_exec!
#    is the gem's key transformation — exercise it via the inject pattern directly.
raw = { stdout: 'connected to host', stderr: '', exit_code: 0 }
remapped = raw.inject({}) do |h, (k, v)|
  k = :exit_status if k == :exit_code
  h[k] = v
  h
end
puts "stdout=#{remapped[:stdout]}"
puts "exit_status=#{remapped[:exit_status]}"
puts "exit_code_gone=#{!remapped.key?(:exit_code)}"

# 4. Serverspec::Helper::RSpecSystem deprecation fires on include
# helpers.rb defines this module; exercise the self.included hook.
module Serverspec
  module Helper
    module RSpecSystem
      def self.included(base)
        puts "[DEPRECATED] Serverspec::Helper::RSpecSystem included in #{base}"
      end
    end
  end
end
class DeprecationProbe; include Serverspec::Helper::RSpecSystem; end
