# Smoke: google-cloud-profiler-v2 — path helpers and version constant
require_relative "lib/google/cloud/profiler/v2/version"
require_relative "lib/google/cloud/profiler/v2/profiler_service/paths"
require_relative "lib/google/cloud/profiler/v2/export_service/paths"

puts Google::Cloud::Profiler::V2::VERSION
puts Google::Cloud::Profiler::V2::VERSION.class

# ProfilerService path helpers
puts Google::Cloud::Profiler::V2::ProfilerService::Paths.profile_path(project: "my-project", profile: "abc123")
puts Google::Cloud::Profiler::V2::ProfilerService::Paths.project_path(project: "my-project")

# ExportService path helper
puts Google::Cloud::Profiler::V2::ExportService::Paths.project_path(project: "other-project")

# Slash validation guard
begin
  Google::Cloud::Profiler::V2::ProfilerService::Paths.profile_path(project: "bad/project", profile: "x")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Module type checks
puts Google::Cloud::Profiler::V2::ProfilerService::Paths.is_a?(Module)
puts Google::Cloud::Profiler::V2::ExportService::Paths.is_a?(Module)
