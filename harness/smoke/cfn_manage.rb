require_relative "lib/cfn_manage/version"
require_relative "lib/cfn_manage/globals"

puts CfnManage::VERSION
puts CfnManage.asg_wait_state
puts CfnManage.ecs_wait_state
puts CfnManage.true?("true")
puts CfnManage.true?("false")
puts CfnManage.true?("1")
puts CfnManage.dry_run?
puts CfnManage.skip_wait?
