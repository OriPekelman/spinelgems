require_relative "lib/cocoapods_amicable"
puts CocoaPodsAmicable.name
puts CocoaPodsAmicable::TargetIntegratorMixin.name
puts CocoaPodsAmicable::InstallerMixin.name
puts CocoaPodsAmicable::LockfileMixin.name
puts CocoaPodsAmicable.is_a?(Module)
puts CocoaPodsAmicable::TargetIntegratorMixin.is_a?(Module)
