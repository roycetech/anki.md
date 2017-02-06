require './lib/highlighter/base_highlighter'

#
class CSharpHighlighter < BaseHighlighter
  def initialize(param = HighlightersEnum::CSHARP)
    super
  end

  def keywords_file
    'keywords_csharp.txt'
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.c.build
  end

  def string_regex
    RE_QUOTE_DOUBLE
  end

  def regexter_blocks(parser)
    parser.regexter('annotations', /^\[.*\]$/m)
  end
end
