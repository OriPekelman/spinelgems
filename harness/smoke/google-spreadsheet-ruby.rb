# Smoke test for google-spreadsheet-ruby 0.3.1
# The gem's entire lib is:
#   require "google_drive"
#   GoogleSpreadsheet = GoogleDrive
# We stub google_drive so the alias line executes under CRuby; Spinel
# will skip the require, leaving GoogleDrive undefined, causing NameError.

# Pre-define google_drive stub so CRuby can load the gem
module GoogleDrive
  def self.login_with_oauth(token, proxy = nil)
    "session:#{token}"
  end

  def self.saved_session(config = nil, proxy = nil, cid = nil, csec = nil)
    "saved:#{config}"
  end
end
$LOADED_FEATURES << 'google_drive'

# Now load the actual gem file
require 'google_spreadsheet'

# Verify alias
puts GoogleSpreadsheet.name
puts GoogleSpreadsheet.equal?(GoogleDrive) ? "alias:ok" : "alias:mismatch"
puts GoogleSpreadsheet.login_with_oauth("tok")
puts GoogleSpreadsheet.saved_session("/tmp/cfg")
