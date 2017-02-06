require 'simplecov'

SimpleCov.start
UNIT_TEST = true

# require './bin/main_class'
require './lib/class_extensions'
require './spec/spec_utils'
require './lib/mylogger'

# Minimal logging when testing.
MyLogger.instance.level = Logger::WARN
LOGGER = MyLogger.instance.freeze
