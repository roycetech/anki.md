require './lib/highlighter/base_highlighter'

class RubyHighlighter < BaseHighlighter
  include HtmlUtils

  def initialize
    super(HighlightersEnum::RUBY)
  end

  def keywords_file
    'keywords_ruby.txt'
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.perl.build
  end

  def string_regex
    RE_QUOTE_BOTH
  end

  def regexter_singles(parser)
    parser.regexter('|vars,...|', /\|.*?\|/, lambda do |token, _re|
      wrappexter(SourceParser.new, 'var', /\w+/, :var).parse(token)
    end)
    wrappexter(parser, 'globals', /\$\w+/, :var)
  end
end # end of RubyHighlighter class
