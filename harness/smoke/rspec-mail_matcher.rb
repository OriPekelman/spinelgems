# smoke: rspec-mail_matcher
# Exercises the matcher classes directly without rspec or the mail gem.
# Each matcher is self-contained; we stub a minimal mail-like struct.

require 'rspec-mail_matcher'

# Minimal mail stub — mimics the interface the matchers use
FakeMail = Struct.new(:to, :from, :subject, :body_text, :multipart) do
  def multipart?
    multipart
  end
  def text?
    true
  end
  def body
    body_text
  end
end

mail = FakeMail.new(
  ["alice@example.com", "bob@example.com"],
  ["sender@example.com"],
  "Welcome to SpinelGems!",
  "Hello Alice, your account is ready.",
  false
)

# --- SubjectMatcher ---
sm_string = RSpec::MailMatcher::SubjectMatcher.new("SpinelGems")
puts sm_string.matches?(mail)               # true
puts sm_string.description                  # have subject including "SpinelGems"

sm_regex = RSpec::MailMatcher::SubjectMatcher.new(/Welcome/)
puts sm_regex.matches?(mail)               # true
puts sm_regex.description                  # have subject matching /Welcome/

sm_no = RSpec::MailMatcher::SubjectMatcher.new("Goodbye")
puts sm_no.matches?(mail)                  # false
puts sm_no.failure_message                 # failure text

# --- DeliverToMatcher ---
dt_match = RSpec::MailMatcher::DeliverToMatcher.new("alice@example.com")
puts dt_match.matches?(mail)               # true
puts dt_match.description                  # have deliver to as alice@example.com

dt_no = RSpec::MailMatcher::DeliverToMatcher.new("unknown@example.com")
puts dt_no.matches?(mail)                  # false
puts dt_no.failure_message                 # failure text

# --- DeliverFromMatcher ---
df_match = RSpec::MailMatcher::DeliverFromMatcher.new("sender@example.com")
puts df_match.matches?(mail)               # true
puts df_match.description                  # have deliver from as sender@example.com

# --- BodyTextMatcher (plain body) ---
bt_match = RSpec::MailMatcher::BodyTextMatcher.new("account is ready")
puts bt_match.matches?(mail)               # true
puts bt_match.description                  # have body including "account is ready"

bt_regex = RSpec::MailMatcher::BodyTextMatcher.new(/Hello \w+/)
puts bt_regex.matches?(mail)              # true
puts bt_regex.description                 # have body matching /Hello \w+/

bt_no = RSpec::MailMatcher::BodyTextMatcher.new("nonexistent text")
puts bt_no.matches?(mail)                 # false
puts bt_no.failure_message                # failure text

# --- VERSION ---
puts RSpec::MailMatcher::VERSION          # 0.1.3
