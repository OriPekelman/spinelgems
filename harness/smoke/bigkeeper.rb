require_relative "lib/big_keeper/version"
require_relative "lib/big_keeper/model/gitflow_type"

puts BigKeeper::VERSION
puts BigKeeper::GitflowType::FEATURE
puts BigKeeper::GitflowType::HOTFIX
puts BigKeeper::GitflowType::RELEASE
puts BigKeeper::GitflowType.name(BigKeeper::GitflowType::FEATURE)
puts BigKeeper::GitflowType.name(BigKeeper::GitflowType::HOTFIX)
puts BigKeeper::GitflowType.name(BigKeeper::GitflowType::RELEASE)
puts BigKeeper::GitflowType.base_branch(BigKeeper::GitflowType::FEATURE)
puts BigKeeper::GitflowType.base_branch(BigKeeper::GitflowType::HOTFIX)
