require './lib/utils/html_utils'
require './lib/wrappexter'

class KeywordHighlighter
  include Wrappexter
  include HtmlUtils

  # argument must be truthy and has contents.
  def initialize(keywords_filename)
    raise 'Keywords required' unless keywords_filename

    @keywords = get_keywords(keywords_filename)
    raise 'Keywords required' if @keywords.empty?
  end

  def get_keywords(keywords_file)
    File.read("./data/#{keywords_file}").each_line.collect(&:chomp)
  end

  def register_to(parser)
    regexp = /(?<!\.|-|(?:[\w]))(?:#{@keywords.join('|')})\b/
    wrappexter(parser, 'keyword', regexp, :keyword)
  end
end
