require_relative "lib/google/cloud/bigtable/v2/bigtable/paths"

include Google::Cloud::Bigtable::V2::Bigtable::Paths

puts table_path(project: "my-project", instance: "my-instance", table: "my-table")
puts instance_path(project: "my-project", instance: "my-instance")
puts authorized_view_path(project: "p1", instance: "i1", table: "t1", authorized_view: "av1")
puts materialized_view_path(project: "p2", instance: "i2", materialized_view: "mv2")
