require './lib/utils/html_utils'

# Code Store for tagging bold and italic from card text.  Bold is used
# for non-code, while italic can be used for both code, and non-code.
module Markdown
  include HtmlUtils

  BOLD = {
    regexp: /(_{2}|\*{2})(.*?)\1/,
    lambda: ->(token, regexp) { "<b>#{token[regexp, 2]}</b>" }
  }.freeze

  ITALIC = {
    regexp: /(?<!\\)([_*])((?:(?:\\\1)|[^\1])+?)\1/,
    lambda: ->(token, regexp) { "<i>#{token[regexp, 2]}</i>" }
  }.freeze

  def number(key = nil)
    hash = {
      regexp: /(?<=\s|\()[+-]?(?:[1-9]\d*|0)(?:\.\d+)?(?!-|\.|\d|,\d)/,
      lambda: ->(token, _regexp) { wrap(:num, token) }
    }

    return hash[key] if key

    hash
  end

  def mark(string)
    parser = SourceParser.new
    parser.regexter('wells', Code::RE_WELL)
    parser.regexter('inlines', Inline::RE_HTML_PATTERN)

    parser.regexter('bold', BOLD[:regexp], BOLD[:lambda])
    parser.regexter('italic', ITALIC[:regexp], ITALIC[:lambda])
    parser.parse(string)
  end
end
