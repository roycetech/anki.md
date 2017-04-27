#
class GitHighlighter < BaseHighlighter
  include RegexpUtils

  def initialize
    super(HighlightersEnum::GIT)
  end

  def keywords_file
    'keywords_git.txt'
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.none.build
  end

  def string_regex
    RE_QUOTE_DOUBLE
  end

  def regexter_singles(parser)
    # /b results in no match.

    ->(arg) { arg * 2 }

    parser.regexter('optional', /\[.+?\]/, ->(token, _regexp) { wrap(:opt, token) })

    parser.regexter('option', /-[a-z-]+\b/,
                    lambda do |token, _regexp|
                      wrap(:opt, token)
                    end)

    parser.regexter('git', /\bgit\b/, ->(token, _regexp) { wrap(:cmd, token) })
  end
end
