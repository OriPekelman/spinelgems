require 'trailblazer-loader'

# 1. Version
puts Trailblazer::Loader::VERSION

# 2. Pipeline construction and calling
# Build a simple pipeline of lambdas and confirm composition works
double   = ->(input, _opts) { input.map { |x| x * 2 } }
add_one  = ->(input, _opts) { input.map { |x| x + 1 } }

pipe = Trailblazer::Loader::Pipeline[double, add_one]
result = pipe.call([1, 2, 3], {})
puts result.inspect   # => [3, 5, 7]

# 3. Pipeline::Collect applies inner pipeline to each element individually
# Each element is an array here; double then add_one applied per element
inner = Trailblazer::Loader::Pipeline[double, add_one]
collector = Trailblazer::Loader::Pipeline::Collect[double, add_one]
result2 = collector.call([[1, 2], [3, 4]], {})
puts result2.inspect  # => [[3, 5], [7, 9]]

# 4. SortByLevel lambda — sorts paths by depth (number of path separators)
paths = [
  "app/concepts/api/v1/comment/",
  "app/concepts/comment/",
  "app/concepts/api/comment/",
]
sorted = Trailblazer::Loader::SortByLevel.(paths, {})
puts sorted.map { |p| p.chomp("/").split("/").last }.inspect
# => ["comment", "comment", "comment"] but sorted by depth:
# comment (3 parts), api/comment (4 parts), api/v1/comment (5 parts)
puts sorted.map { |p| p.split("/").size }.inspect  # => [3, 4, 5]

# 5. SortOperationLast lambda — operation.rb files go to end
files = [
  "app/concepts/comment/operation.rb",
  "app/concepts/comment/contract.rb",
  "app/concepts/comment/callback.rb",
]
sorted_ops = Trailblazer::Loader::SortOperationLast.(files, {})
puts sorted_ops.last.include?("operation").inspect  # => true

# 6. concept_dirs default list
loader = Trailblazer::Loader.new
dirs = loader.concept_dirs
puts dirs.include?("operation").inspect   # => true
puts dirs.include?("contract").inspect    # => true
puts dirs.length.inspect                  # => 14
