require './lib/highlighter/base_highlighter'

#
class JavaHighlighter < BaseHighlighter
  def initialize(param = HighlightersEnum::JAVA)
    super
  end

  def keywords_file
    'keywords_java.txt'
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.c.build
  end

  def string_regex
    RE_QUOTE_DOUBLE
  end

  def regexter_singles(parser)
    wrappexter(parser, 'char', /'\\?.{0,1}'/, :quote)
    wrappexter(parser, 'annotation', /@[a-z_A-Z]+/, :ann)

    parser.regexter(:num, number[:regexp], number[:lambda])
  end
end
