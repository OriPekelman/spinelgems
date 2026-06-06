require 'guachiman'

# Guachiman is an authorization module.
# Extend an object with it, define rules via allow(), query with allow?().

class Policy
  extend Guachiman

  allow :admin, :read, :write, :delete
  allow :editor, :read, :write
  allow :viewer, :read
  allow :editor, :publish do |obj|
    obj[:approved]
  end
end

# Basic permission checks
puts Policy.allow?(:admin, :read).inspect    # true
puts Policy.allow?(:admin, :write).inspect   # true
puts Policy.allow?(:admin, :delete).inspect  # true
puts Policy.allow?(:editor, :read).inspect   # true
puts Policy.allow?(:editor, :write).inspect  # true
puts Policy.allow?(:editor, :delete).inspect # false
puts Policy.allow?(:viewer, :read).inspect   # true
puts Policy.allow?(:viewer, :write).inspect  # false

# Block-based conditional permission
puts Policy.allow?(:editor, :publish, { approved: true }).inspect  # true
puts Policy.allow?(:editor, :publish, { approved: false }).inspect # false

# Unknown group
puts Policy.allow?(:guest, :read).inspect    # false

# VERSION constant
puts Guachiman::VERSION
