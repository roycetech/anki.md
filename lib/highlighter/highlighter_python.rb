require './lib/highlighter/base_highlighter'

class PythonHighlighter < BaseHighlighter
  def initialize
    super(HighlightersEnum::PYTHON)
  end

  def keywords_file
    'keywords_python.txt'
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.perl.build
  end

  def string_regex
    RE_QUOTE_BOTH
  end

  def regexter_blocks(parser)
    wrappexter(parser, 'multiline string', /(['"]{3})[\d\D]*\1/, :quote)
    wrappexter(parser, 'raw string', /r(['"]).*\1/, :quote)
  end

  def regexter_singles(parser)
    parser.regexter('Number Anywhere', number(:regexp), number(:lambda))

    num_token = /^[+-]?[1-9]\d*(?:\.\d+)?$/
    parser.regexter('Number Token', num_token, number(:lambda))
  end
end
