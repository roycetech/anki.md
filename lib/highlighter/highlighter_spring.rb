require './lib/highlighter/highlighter_java'

#
class SpringHighlighter < JavaHighlighter
  include RegexpUtils, HtmlUtils

  def initialize
    super(HighlightersEnum::SPRING)
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.c.html.build
  end

  def string_regex
    RE_QUOTE_DOUBLE
  end

  RE1 = %r{
    <            # match open angle bracket
    (            # capture as first group
      \/?        # optionally followed by forward slash
      [a-z]+     # match
      :          # match the text ':'
      [a-zA-Z-]+ # match 1 or more, lower or upper cased alphabet
      \/?        # optionally followed by forward slash
    )
    >            # match closing angle bracket
  }x

  def regexter_blocks(parser)
    parser.regexter('noattr_xml', RE1, lambda do |_t, _r|
      wrap(:html, ELT + token[regexp, 1] + EGT)
    end)

    regexter_xml_withattr(parser)
  end

  private

  def regexter_xml_withattr(parser)
    parser.regexter('withattr_xml', /<.*?>/, lambda do |token, _r|
      inner_parser = SourceParser.new

      regexter_sec_elem(inner_parser)
      regexter_name_value(inner_parser)
      regexter_closing(inner_parser)

      inner_parser.parse(token)
    end)
  end

  def regexter_name_value(parser)
    parser.regexter(
      'name="value"',
      /\s([a-z]+) ?= ?(".*?")/,
      ->(t, r) { " #{wrap(:attr, t[r, 1])}=#{wrap(:quote, t[r, 2])}" }
    )
  end

  def regexter_closing(parser)
    parser.regexter(
      'closing',
      %r{(\/?)>},
      ->(t, r) { wrap(:html, t[r, 1] + EGT) }
    )
  end

  def regexter_sec_elem(parser)
    parser.regexter(
      '<sec:elem',
      /<([a-z]+:[a-zA-Z-]+)/,
      ->(t, r) { wrap(:html, ELT + t[r, 1]) }
    )
  end
end
