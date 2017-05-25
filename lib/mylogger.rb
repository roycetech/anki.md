require 'singleton'
require 'logger'

#
class MyLogger
  include Singleton

  RAKE = 3
  SUBLIMETEXT = 4 # 2 & 3
  METHODS = %i(info debug warn level debug?).freeze

  def initialize
    @logger = Logger.new(STDOUT)
    @logger.formatter = proc do |severity, _datetime, _progname, msg|
      line = caller[SUBLIMETEXT]
      source = line[line.rindex('/', -1) + 1..-1]
      "#{severity} #{source} - #{msg}\n"
    end
  end

  def respond_to_missing?(method_symbol)
    METHODS.include? method_symbol
  end

  def method_missing(name, *args)
    return super unless respond_to_missing?(name)

    @logger.send(name, *args)
  end

  def level=(value)
    @logger.level = value
  end
end
