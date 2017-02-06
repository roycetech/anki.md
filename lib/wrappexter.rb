#
module Wrappexter
  extend HtmlUtils

  def wrappexter(parser, description, regexp, klass)
    parser.regexter(
      description,
      regexp,
      lambda do |ltoken, _lregexp|
        wrap(klass, ltoken)
      end
    )
    parser
  end
end
