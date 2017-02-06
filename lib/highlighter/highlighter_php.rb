require './lib/highlighter/base_highlighter'

#
class PhpHighlighter < BaseHighlighter
  include RegexpUtils

  def initialize
    super(HighlightersEnum::PHP)
  end

  def keywords_file
    'keywords_php.txt'
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.perl.c.build
  end

  def string_regex
    RE_QUOTE_BOTH
  end

  def regexter_singles(parser)
    parser.regexter(
      'php_tags',
      /<\?=|<\?(?:php)?|\?>/,
      ->(token, _regexp) { wrap(:phptag, escape_angles(token)) }
    )
    wrappexter(parser, 'php_vars', /(\$[\w]+)/, :var)
  end
end
