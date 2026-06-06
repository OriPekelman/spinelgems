# Smoke test for vsphere-automation-sdk
# This is an umbrella/meta gem: loading it defines the VSphereAutomation namespace
# that all sub-gems (runtime, cis, vcenter, appliance, content, vapi) populate.
# The smoke exercises the namespace extension patterns sub-gems rely on.

require 'vsphere-automation-sdk'

# Extend the namespace as sub-gems would: add service modules + a model class.
module VSphereAutomation
  def self.describe
    "VMware vSphere Automation SDK"
  end

  module CIS
    def self.describe
      "CIS service stub"
    end
  end

  module VCenter
    def self.describe
      "vCenter service stub"
    end
  end
end

puts VSphereAutomation.describe
puts VSphereAutomation::CIS.describe
puts VSphereAutomation::VCenter.describe

# Model class pattern used by vsphere-automation-cis etc.
class VSphereAutomation::CIS::AboutInfo
  def initialize(version, build)
    @version = version
    @build   = build
  end

  def version
    @version
  end

  def build
    @build
  end

  def to_s
    "AboutInfo version=#{@version} build=#{@build}"
  end
end

info = VSphereAutomation::CIS::AboutInfo.new("7.0.3", "19480866")
puts info.version
puts info.build
puts info.to_s
