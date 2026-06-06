# chef-metal smoke
# This gem is a pure backwards-compat shim: every .rb file contains
# only `require "chef/provisioning/..."`. Zero logic is defined here.
# require 'chef_metal' immediately delegates to chef/provisioning,
# a separate gem — causing a LoadError when chef-provisioning is absent.
#
# SMOKE-ERROR: no smokeable logic; all substance lives in chef-provisioning.
require 'chef_metal'
