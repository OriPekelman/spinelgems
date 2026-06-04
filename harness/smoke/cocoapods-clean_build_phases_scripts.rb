# Smoke: cocoapods-clean_build_phases_scripts
# The harness pre-pends require_relatives for all lib files, so no require here.
# We stub Pod::Command and CLAide so the command subclass loads cleanly.
# Then we exercise the phase-name matching logic and the options method.

# --- minimal stubs for external deps (CLAide, Pod) which Spinel ignores ---
module CLAide
  class Argument
    def initialize(name, required)
      @name = name
      @required = required
    end
    def to_s; "<#{@name}>"; end
  end

  class ARGV
    def initialize(args = [])
      @args = args.dup
    end
    def option(name); nil; end
    def flag(name, default = false); default; end
  end
end

module Pod
  class Command
    def self.summary=(s); @summary = s; end
    def self.description=(d); @description = d; end
    def self.arguments=(a); @arguments = a; end
    def self.options; []; end
    def initialize(argv = nil); end
    def validate!; end
  end
end

# 1. VERSION constant
puts CocoapodsCleanBuildPhasesScripts::VERSION

# 2. Module name
puts CocoapodsCleanBuildPhasesScripts.name

# 3. Command class is accessible
klass = Pod::Command::CleanBuildPhasesScripts
puts klass.name

# 4. summary is set on the class
puts klass.instance_variable_get(:@summary)

# 5. Instantiate with nil argv
cmd = klass.new(nil)
puts cmd.class.name

# 6. Phase-name matching logic (core algorithm from #clean method):
#    phases whose name ends with '[CP] Copy Pods Resources' are selected
phase_name = '[CP] Copy Pods Resources'
candidate_names = [
  "[CP] Copy Pods Resources",
  "Compile Sources",
  "MyTarget [CP] Copy Pods Resources",
  "[CP] Copy Pods Resources Extra",
]
matches = candidate_names.select { |n| n.end_with?(phase_name) }
puts matches.length
puts matches.first

# 7. options returns array with xcodeproj option prepended to super
opts = klass.options
puts opts.class
puts opts.length
puts opts.first.first
