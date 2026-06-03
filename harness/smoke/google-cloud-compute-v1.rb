# frozen_string_literal: true
# Smoke: exercises pure-Ruby GrpcTranscoding URL builders and version constant.
# grpc_transcoding.rb files have no external requires — pure Ruby URL building.
require "google/cloud/compute/v1/version"
require "google/cloud/compute/v1/instances/rest/grpc_transcoding"
require "google/cloud/compute/v1/accelerator_types/rest/grpc_transcoding"
require "google/cloud/compute/v1/addresses/rest/grpc_transcoding"

puts Google::Cloud::Compute::V1::VERSION
puts Google::Cloud::Compute::V1::VERSION.class

# Duck-typed request stub — no protobuf needed.
Request = Struct.new(:project, :zone, :instance, :accelerator_type,
                     :region, :address, :filter, :max_results,
                     keyword_init: true) do
  def has_filter?   = !filter.nil?
  def has_max_results? = !max_results.nil?
  def has_order_by? = false
  def has_page_token? = false
  def has_return_partial_success? = false
  def has_include_all_scopes? = false
end

tc_inst = Google::Cloud::Compute::V1::Instances::Rest::GrpcTranscoding

req = Request.new(project: "my-project", zone: "us-central1-a", instance: "my-vm")
uri, body, params = tc_inst.transcode_get(req)
puts uri
puts body.inspect
puts params.inspect

req2 = Request.new(project: "my-project", zone: "us-central1-a", filter: "status=RUNNING", max_results: 50)
uri2, body2, params2 = tc_inst.transcode_list(req2)
puts uri2
puts params2["filter"]
puts params2["maxResults"]

tc_accel = Google::Cloud::Compute::V1::AcceleratorTypes::Rest::GrpcTranscoding
req3 = Request.new(project: "proj", zone: "us-east1-b", accelerator_type: "nvidia-tesla-k80")
uri3, _body3, params3 = tc_accel.transcode_get(req3)
puts uri3
puts params3.inspect

tc_addr = Google::Cloud::Compute::V1::Addresses::Rest::GrpcTranscoding
req4 = Request.new(project: "proj", region: "us-west1", max_results: 10)
uri4, _body4, params4 = tc_addr.transcode_list(req4)
puts uri4
puts params4["maxResults"]
