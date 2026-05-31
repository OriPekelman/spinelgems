repo = Feature::Repository::SimpleRepository.new
repo.add_active_feature(:search)
repo.add_active_feature(:beta)

Feature.set_repository(repo)

puts Feature.active?(:search)
puts Feature.active?(:beta)
puts Feature.inactive?(:search)
puts Feature.inactive?(:missing)

Feature.with(:search) { puts "search on" }
Feature.without(:missing) { puts "missing off" }

puts Feature.switch(:beta, "yes", "no")
puts Feature.switch(:missing, "yes", "no")
puts Feature.active_features.sort.inspect
