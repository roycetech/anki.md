#
class JsHighlighter < BaseHighlighter
  def initialize
    super(HighlightersEnum::JS)
  end

  def keywords_file
    'keywords_js.txt'
  end

  def string_regex
    RE_QUOTE_BOTH
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.c.build
  end
end
