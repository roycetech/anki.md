#
class SqlHighlighter < BaseHighlighter
  def initialize
    super(HighlightersEnum::SQL)
  end

  def keywords_file
    'keywords_sql.txt'
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.c.sql.build
  end

  def string_regex
    RE_QUOTE_SINGLE
  end

  RE1 = /
    \b              # Word boundary
    TIMESTAMP       # match the text 'TIMESTAMP'
    (?:             # Optionally followed by nno-captured group
      \sWITH        # match the text ' WITH'
      (?: \sLOCAL)? # Optionally followed by text ' LOCAL'
      \sTIME\sZONE  # match the text ' TIME ZONE'
    )?
  /x

  RE2 = /
    INTERVAL        # match the text 'INTERVAL'
    (?:\s'\d+
      (?:-\d+)?
    ')?
    \s              # Whitespace
    (?:YEAR|MONTH)  # math the text 'YEAR' or 'MONTH'
    (?:\(\d\))?     # Optionally a single digit between parenthesis
    (?:\sTO MONTH)? # Optionally match text ' TO MONTH'
  /x

  RE3 = /
    INTERVAL
    (?: '[\d: \.]+')?
    \s(?:DAY|HOUR|MINUTE|SECOND)
    (?:\(\d+
      (?:,\d+)?
      \)
    )?
    (?:\sTO\s
      (?:HOUR|MINUTE|SECOND)
      (?:\(\d+\))?
    )?
  /x

  def regexter_blocks(parser)
    wrappexter(parser, 'optional param', /\[.*\]/, :opt)
    wrappexter(parser, 'datatype', RE1, :keyword)
    parser.regexter('WITHIN GROUP', /WITHIN GROUP/)
    wrappexter(parser, 'INTERVAL_YM', RE2, :keyword)
    wrappexter(parser, 'INTERVAL_DS', RE3, :keyword)
  end
end
