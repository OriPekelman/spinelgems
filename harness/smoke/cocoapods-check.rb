# smoke: cocoapods-check — exercises Pod::Command::Check formatting logic
# The gem is a CocoaPods plugin; Pod::Command is provided by cocoapods (not
# this gem), so we stub the minimal DSL needed to load check.rb, then call
# the real formatting methods with concrete inputs.

require 'cocoapods_check'
puts CocoapodsCheck::VERSION   # verify the constant resolves

# Stub the CocoaPods infrastructure (not part of this gem)
module Pod
  class Command
    def self.summary=(v);     @summary = v; end
    def self.summary;         @summary;     end
    def self.description=(v); @desc = v;    end
    def self.description;     @desc;        end
    def self.arguments=(v);   @args = v;    end
    def self.arguments;       @args || [];  end
    def self.options;         [];           end
    def initialize(_argv);    end
  end
end

# Load the actual command class (opens Pod::Command::Check)
require 'pod/command/check'

# --- helper: build a Check instance with given verbose flag ---
def make_checker(verbose:)
  obj = Pod::Command::Check.allocate
  obj.instance_variable_set(:@check_command_verbose, verbose)
  obj.instance_variable_set(:@check_command_ignore_dev_pods, false)
  obj
end

quiet   = make_checker(verbose: false)
verbose = make_checker(verbose: true)

# --- 1. changed_result: version bump (manifest -> locked) ---
puts quiet.changed_result('Alamofire', '5.6.0', '5.7.0')
puts verbose.changed_result('Alamofire', '5.6.0', '5.7.0')

# --- 2. added_result: pod not yet installed ---
puts quiet.added_result('RxSwift')
puts verbose.added_result('RxSwift')

# --- 3. changed_development_result: dev pod with file changes ---
#     verbose mode: shows up to 2 files + "and N others"
files = ['Sources/MyPod/Foo.swift', 'Sources/MyPod/Bar.swift', 'Sources/MyPod/Baz.swift']
puts quiet.changed_development_result('MyDevPod', files)
puts verbose.changed_development_result('MyDevPod', files)

# --- 4. get_podspec_for_file_or_path: identity when filename contains .podspec ---
puts quiet.get_podspec_for_file_or_path('MyLib/MyLib.podspec')
puts quiet.get_podspec_for_file_or_path('MyLib/MyLib.podspec.json')
