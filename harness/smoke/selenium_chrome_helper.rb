# frozen_string_literal: true

# selenium_chrome_helper smoke
# Stubs Rails, Capybara and Selenium::WebDriver so the Railtie can be loaded
# without those runtime deps; then exercises real gem logic.

require 'pathname'

# Stub rails/railtie before require fires
$LOADED_FEATURES << 'rails/railtie'

module Rails
  class Railtie
    def self.rake_tasks(&block); end
    def self.initializer(name, &block); end
    def self.inherited(klass); end
  end
end

$LOADED_FEATURES << 'capybara'
$LOADED_FEATURES << 'selenium/webdriver'

module Capybara
  def self.register_driver(name, &block); end
end

# Minimal Selenium stubs — track configure_browser_options side effects
$opts_args = []
$opts_binary = nil

module Selenium
  module WebDriver
    module Chrome
      class Options
        def binary=(path)
          $opts_binary = path
        end
        def add_argument(arg)
          $opts_args << arg
        end
      end
      class Service
        def self.driver_path=(path); end
      end
    end
  end
end

require 'selenium_chrome_helper'

# 1. VERSION constant
puts SeleniumChromeHelper::VERSION

# 2. CHROME_VERSION — ENV-defaulted constant
puts SeleniumChromeHelper::CHROME_VERSION

# 3. Platform detection (pure RUBY_PLATFORM logic in Railtie)
platform = SeleniumChromeHelper::Railtie.platform
puts platform

# 4. base_path with ENV override (avoids Rails.root dependency)
ENV['CHROME_FOR_TESTING_PATH'] = '/tmp/chrome-test'
base = SeleniumChromeHelper::Railtie.base_path
puts base.to_s

# 5. driver_path — path concatenation logic (binary missing, warns to stderr)
driver_path = SeleniumChromeHelper::Railtie.driver_path
puts driver_path.end_with?('chromedriver')

# 6. chrome_path — platform-specific path construction
chrome_path = SeleniumChromeHelper::Railtie.chrome_path
puts chrome_path.include?('chrome')

# 7. configure_browser_options headless: true — exercises options wiring
SeleniumChromeHelper::Railtie.configure_browser_options(headless: true)
puts $opts_args.include?('--headless=new')
puts $opts_args.include?('--no-sandbox')
puts $opts_args.include?('--disable-gpu')
puts $opts_args.include?('--window-size=1400,1400')
