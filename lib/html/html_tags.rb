require 'singleton'
require './lib/file_reader'

#
class HtmlTags
  include Singleton
  attr_reader :names

  def initialize
    @names = FileReader.read_as_list('html_element_names.txt')
  end
end
