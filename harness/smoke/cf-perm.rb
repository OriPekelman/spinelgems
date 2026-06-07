# frozen_string_literal: true
# Smoke for cf-perm 0.0.10 — CloudFoundry permission model library.
# The gem's main entry point chains through google/protobuf + grpc (external
# gems not available in this environment), so we load only the pure-Ruby
# model and error subsystems, which are the real application logic users
# interact with (the client wraps gRPC; the models are returned to callers).

require 'perm/version'
require 'perm/v1/models/base'
require 'perm/v1/models/role'
require 'perm/v1/models/permission'
require 'perm/v1/errors'

# VERSION constant
puts CloudFoundry::Perm::VERSION

# Role model: keyword constructor + attr_reader
role = CloudFoundry::Perm::V1::Models::Role.new(name: 'org_manager')
puts role.name

# Permission model: action + resource_pattern
perm = CloudFoundry::Perm::V1::Models::Permission.new(
  action: 'app.deploy',
  resource_pattern: 'orgs/*/spaces/*'
)
puts perm.action
puts perm.resource_pattern

# BaseModel equality: same class + same ivars → equal; different name → not equal
role_a = CloudFoundry::Perm::V1::Models::Role.new(name: 'developer')
role_b = CloudFoundry::Perm::V1::Models::Role.new(name: 'developer')
role_c = CloudFoundry::Perm::V1::Models::Role.new(name: 'auditor')
puts role_a == role_b
puts role_a == role_c

# Cross-class inequality via BaseModel#==
perm2 = CloudFoundry::Perm::V1::Models::Permission.new(
  action: 'developer',
  resource_pattern: 'x'
)
puts role_a == perm2

# Errors::BadStatus: code / details / message
err = CloudFoundry::Perm::V1::Errors::BadStatus.new(7, 'permission denied', {})
puts err.code
puts err.details
puts err.message

# AlreadyExists subclass
already = CloudFoundry::Perm::V1::Errors::AlreadyExists.new(6, 'role already exists', {})
puts already.class.name.split('::').last
puts already.message
puts already.is_a?(CloudFoundry::Perm::V1::Errors::BadStatus)

# NotFound subclass
not_found = CloudFoundry::Perm::V1::Errors::NotFound.new(5, 'role not found', {})
puts not_found.class.name.split('::').last
puts not_found.message
