# frozen_string_literal: true
# Smoke test for grafeas-v1: exercises Paths helpers (self-contained, no gRPC/network).
# The Paths module does real logic: path interpolation + "/" guard.
require "grafeas/v1/grafeas/paths"
require "grafeas/v1/version"

puts Grafeas::V1::VERSION

paths = Grafeas::V1::Grafeas::Paths

puts paths.note_path(project: "my-project", note: "CVE-2021-44228")
puts paths.occurrence_path(project: "my-project", occurrence: "occ-42")
puts paths.project_path(project: "acme-corp")

# Verify the slash guard raises ArgumentError
begin
  paths.note_path(project: "bad/project", note: "n1")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

begin
  paths.occurrence_path(project: "also/bad", occurrence: "o1")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end
