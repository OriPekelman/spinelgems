require_relative "lib/groundskeeper/version"
require_relative "lib/groundskeeper/semantic_version"
require_relative "lib/groundskeeper/string_utils"

sv = Groundskeeper::SemanticVersion.new("1.2.3")
puts sv.version
puts sv.major
puts sv.minor
puts sv.patch
puts sv.bump("M")
puts sv.bump("m")
puts sv.bump("p")
puts Groundskeeper::VERSION
puts Groundskeeper::StringUtils.underscore("CamelCaseWord")
puts Groundskeeper::StringUtils.underscore("HTMLParser")
