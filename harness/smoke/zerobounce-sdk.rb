require_relative "lib/zerobounce/version"
require_relative "lib/zerobounce/validate_status"
require_relative "lib/zerobounce/validate_sub_status"
require_relative "lib/zerobounce/download_type"
require_relative "lib/zerobounce/api_urls"

puts Zerobounce::VERSION
puts Zerobounce::ValidateStatus::VALID
puts Zerobounce::ValidateStatus::INVALID
puts Zerobounce::ValidateStatus::DO_NOT_MAIL
puts Zerobounce::ValidateSubStatus::DISPOSABLE
puts Zerobounce::ValidateSubStatus::TOXIC
puts Zerobounce::DownloadType::PHASE_1
puts Zerobounce::DownloadType::COMBINED
puts Zerobounce::ApiUrls::DEFAULT_URL
