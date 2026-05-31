require_relative "lib/google/cloud/bigtable/admin/v2/version"
require_relative "lib/google/cloud/bigtable/admin/v2/bigtable_instance_admin/paths"
require_relative "lib/google/cloud/bigtable/admin/v2/bigtable_table_admin/paths"

puts Google::Cloud::Bigtable::Admin::V2::VERSION

include Google::Cloud::Bigtable::Admin::V2::BigtableInstanceAdmin::Paths

puts app_profile_path(project: "my-project", instance: "my-instance", app_profile: "my-profile")
puts cluster_path(project: "my-project", instance: "my-instance", cluster: "my-cluster")
puts instance_path(project: "my-project", instance: "my-instance")
puts location_path(project: "my-project", location: "us-east1")
puts project_path(project: "my-project")
