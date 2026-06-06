# frozen_string_literal: true

require 'onlyoffice_logger_helper'

# Test colorize: wraps text in ANSI escape codes
puts OnlyofficeLoggerHelper.colorize('hello', 32)
puts OnlyofficeLoggerHelper.colorize('world', 31)

# Test color constants
puts OnlyofficeLoggerHelper::GREEN_COLOR_CODE
puts OnlyofficeLoggerHelper::RED_COLOR_CODE

# Test version constants
puts OnlyofficeLoggerHelper::VERSION
puts OnlyofficeLoggerHelper::NAME

# Test that colorize with green code matches green_log color code
green = OnlyofficeLoggerHelper.colorize('test', OnlyofficeLoggerHelper::GREEN_COLOR_CODE)
red   = OnlyofficeLoggerHelper.colorize('test', OnlyofficeLoggerHelper::RED_COLOR_CODE)
puts green == "\e[32mtest\e[0m"
puts red == "\e[31mtest\e[0m"
