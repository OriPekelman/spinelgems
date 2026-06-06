# Smoke: i18n-globals
# The gem extends I18n::Config with a globals accessor and overrides
# I18n.translate to merge globals into every call's options.
# Since Spinel ignores plain `require` to the `i18n` gem, we pre-stub
# the minimal I18n surface the gem reopens, then exercise real logic.

module I18n
  class Config
  end

  class << self
    def translate(*args)
      # base implementation: return args joined for test purposes
      args.inspect
    end
    alias t translate

    def config
      @config ||= Config.new
    end
  end
end

require 'i18n-globals'

# 1. Version constant
puts I18n::Globals::VERSION

# 2. globals defaults to empty hash
c = I18n::Config.new
puts c.globals.class
puts c.globals.inspect

# 3. globals= stores and retrieves
c.globals = { locale: :fr, user: 'Alice', role: 'admin' }
puts c.globals[:locale]
puts c.globals[:user]

# 4. class variable is shared across instances (@@globals is class-level)
c2 = I18n::Config.new
puts c2.globals[:user]
puts c2.globals.length

# 5. merging: a new instance starts with the same class variable
I18n.config.globals = { site: 'example.com', env: 'production' }
c3 = I18n::Config.new
puts c3.globals[:site]
puts c3.globals[:env]

# 6. globals= with empty hash resets
c3.globals = {}
puts c3.globals.inspect
# All instances share the reset
puts I18n::Config.new.globals.inspect
